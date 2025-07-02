---
title: "[Swift] Realm での Auto increment ID + 削除オブジェクトのID再利用防止"
# image: "/images/tech-blog/slug/image.jpg"
description: "Realm Swift で Auto increment ID を実装する方法を紹介する。削除されたオブジェクトのIDを再利用しないようにする方法も紹介する。"
published: "2018-09-09"
updated: "2025-07-02"
category: "tech"
tags: ["ios", "swift", "realm"]
---

Realm Swift 3.8.0 (記事執筆時の最新)の時点では、Auto increment ID の仕組みは存在しない。

> **Auto-incrementing properties:** Realm has no mechanism for thread-safe/process-safe auto-incrementing properties commonly used in other databases when generating primary keys. (以下略)

([Realm 公式ドキュメント](https://realm.io/docs/swift/3.8.0/)より引用)

なので、必要なら自分で実装しなければならない。

しかし、出来るだけ Auto increment ID を採用しないことを私はおすすめする。ID に連続性は必須ではないし、もしも作成順にレコード(Realmではオブジェクトと呼ぶ)をソートしたりする必要があるのならば、そのためのにプロパティを別途設けるべきである。ID には 識別子であること以外の役割を持たせるべきではない。

> However, in most situations where a unique auto-generated value is desired, it isn’t necessary to have sequential, contiguous, integer IDs. A unique string primary key is typically sufficient. A common pattern is to set the default property value to NSUUID().UUIDString to generate unique string IDs.

([Realm 公式ドキュメント](https://realm.io/docs/swift/3.8.0/)より引用)

それでも Auto increment ID を採用したいというのであれば、この記事はいくらか役に立つだろう。

## 単純な Auto increment ID

前提として、`Person`インスタンスの情報を Realm で保存したいものとする。  
`Person` は次のプロパティを持つ。

- `id` (primary key)
- `name`

次の` Person`クラスでは Auto increment ID の単純な実装がされている。

###### Person.swift

```swift
import RealmSwift

class Person: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    // ID を increment して返す
    static func newID(realm: Realm) -> Int {
        if let person = realm.objects(Person.self).sorted(byKeyPath: "id").last {
            return person.id + 1
        } else {
            return 1
        }
    }

    // increment された ID を持つ新規 Person インスタンスを返す
    static func create(realm: Realm) -> Person {
        let person: Person = Person()
        person.id = newID(realm: realm)
        return person
    }
}
```

`create`メソッドを呼び出すと、auto increment された ID を持つ新規 Person インスタンスが得られる。

```swift
let realm: Realm = try! Realm()
let firstPerson: Person = Person.create(realm: realm)
firstPerson.name = "Alice"
try! realm.write {
    realm.add(firstPerson)
}
```

上記のコードを実行すると、 ["id": 1, "name": "Alice"] のオブジェクトが保存される。

### オブジェクト削除後に起こる問題: ID再利用

前述のコードで id: 1 の `firstPerson` を保存するだけなら何ら問題はない。

しかし`firstPerson`が削除されると、後の新しいオブジェクトで id が使い回されてしまうという問題が起こる。

```swift
try! realm.write {
    realm.delete(firstPerson)
}

let secondPerson: Person = Person.create(realm: realm)
secondPerson.name = "Bob"
try! realm.write {
    realm.add(secondPerson)
}
```

上記コードでは `secondPerson` の id は **1** となる。

これでは、主キーが持つべき次の性質に反する。

> 永続的：レコードが一度作られれば、そこに振られた主キーは中身が変化しようとも変化せず、レコードを削除しても再利用すべきではありません。

([https://qiita.com/jkr_2255/items/5a71ff5f8569c5e0f24d](https://qiita.com/jkr_2255/items/5a71ff5f8569c5e0f24d) より引用)

`secondPerson`では、 id が **2** になっていて欲しい。

## ID再利用を防いだ Auto increment ID

削除済みオブジェクトで使われていた ID を再利用することなく、 ID が auto incremant されるようにしたい。

そのために、(ID順での)最後のオブジェクトとして常にダミーオブジェクトがあるようにする。  
ダミーオブジェクトをわざわざ削除するようなことはない(はず)なので、新しいオブジェクトには何番の ID を採番すればよいのかが常にはっきりしている。

そして、新しく(ダミーでない)オブジェクトを追加したい場合には、ダミーオブジェクトに情報を付加して更新し、続いて新しいダミーオブジェクトを追加する。

では、`Person.create`メソッドを書き換えよう。

```swift
static func create(realm: Realm, asDummy: Bool = false) -> Person {
    if asDummy {
        let newDummyPerson: Person = Person()
        newDummyPerson.id = Person.newID(realm: realm)
        return newDummyPerson
    } else {
        let lastID: Int = (realm.objects(Person.self).sorted(byKeyPath: "id").last?.id)!
        let dummyPerson: Person = realm.object(ofType: Person.self, forPrimaryKey: lastID)!
        let newDummyPerson: Person = Person.create(realm: realm, asDummy: true)
        try! realm.write {
            realm.add(newDummyPerson)
        }
        return dummyPerson
    }
}
```

これで、`secondPerson`は id: **2** として保存される。

```swift
let try! realm: Realm = Realm()

// DB作成後、まずダミーオブジェクトを追加
let dummyPerson: Person = Person.create(realm: realm, asDummy: true)
try! realm.write {
    realm.add(dummyPerson)
}
// => 1:(dummy)

// firstPerson を保存
let firstPerson: Person = Person.create(realm: realm)
try! realm.write {
    firstPerson.name = "Alice"
}
// => 1:Alice, 2:(dummy)

// firstPerson を削除
try! realm.write {
    realm.delete(firstPerson)
}
// => 2:(dummy)

// secondPerson を保存
let secondPerson: Person = Person.create(realm: realm)
try! realm.write {
    secondPerson.name = "Bob"
}
// => 2:Bob, 3:(dummy)
```

### コード全体

最後に、コード全体を掲載する。  
[GitHub](https://github.com/hahnah/til-swift/tree/master/RealmAutoIncrementalID)に同じコードを公開している。

###### Person.swift

```swift
import RealmSwift

class Person: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    // ID を increment して返す
    static func newID(realm: Realm) -> Int {
        if let person = realm.objects(Person.self).sorted(byKeyPath: "id").last {
            return person.id + 1
        } else {
            return 1
        }
    }

    // increment された ID を持つ新規 Person オブジェクトを返す
    static func create(realm: Realm, asDummy: Bool = false) -> Person {
        if asDummy {
            let newDummyPerson: Person = Person()
            newDummyPerson.id = Person.newID(realm: realm)
            return newDummyPerson
        } else {
            let lastID: Int = (realm.objects(Person.self).sorted(byKeyPath: "id").last?.id)!
            let dummyPerson: Person = realm.object(ofType: Person.self, forPrimaryKey: lastID)!
            let newDummyPerson: Person = Person.create(realm: realm, asDummy: true)
            try! realm.write {
                realm.add(newDummyPerson)
            }
            return dummyPerson
        }
    }

}
```

###### ViewController.swift (iOSで動作確認用)

```swift
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let realm: Realm = try! Realm()

        // delete all
        try! realm.write {
            realm.deleteAll()
        }

        // dummy person
        let dummyPerson: Person = Person.create(realm: realm, asDummy: true)
        try! realm.write {
            realm.add(dummyPerson)
        }
        self.printPeople(realm: realm)

        // first person
        let firstPerson: Person = Person.create(realm: realm)
        try! realm.write {
            firstPerson.name = "Alice"
        }
        self.printPeople(realm: realm)

        // delete first person
        try! realm.write {
            realm.delete(firstPerson)
        }
        self.printPeople(realm: realm)

        // second person
        let secondPerson: Person = Person.create(realm: realm)
        try! realm.write {
            secondPerson.name = "Bob"
        }
        self.printPeople(realm: realm)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func printPeople(realm: Realm) {
        let people: Array<Person> = Array(realm.objects(Person.self).sorted(byKeyPath: "id"))
        people.forEach { (person: Person) in
            print(person.id, person.name)
        }
        print("---------------")
    }

}
```

## 参考

- [GitHub](https://github.com/hahnah/til-swift/tree/master/RealmAutoIncrementalID)
- [Realm Swift 3.8.0 公式ドキュメント](https://realm.io/docs/swift/3.8.0/)
- [https://qiita.com/jkr_2255/items/5a71ff5f8569c5e0f24d](https://qiita.com/jkr_2255/items/5a71ff5f8569c5e0f24d)
