---
title: "React Hook Form の使い方・使い分け"
# image: "/images/tech-blog/slug/image.jpg"
description: "React Hook Form は React でフォームを扱うためのライブラリだ。React Hook Form に複数の使い方が存在するが、どういう場合にどの使い方を選ぶべきかについて解説する。"
published: "2025-07-06"
updated: "2025-07-08"
category: "tech"
tags: ["typescript", "react", "react-hook-form"]
---

## useForm パターン

まずは最も単純な、`useForm` だけを使うパターン。

useForm を使うコンポーネント内でHTMLネイティブの `input` 要素などを扱っている場合に使える。

`input` 要素など(ネイティブなフォーム入力要素)に、`useForm` から得られる `register` メソッドを渡すことで、その `input` 要素を React Hook Form の管理下に置くことができる。

```tsx
import { useForm } from "react-hook-form";

export const MyUI = () => {
  // useForm から register などを得る。これらを使ってフォームの制御をする
  const { register, handleSubmit } = useForm({
    defaultValues: {
      firstName: "",
      lastName: "",
      category: "",
    },
  });

  // input や select などの要素に register を渡すことで、React Hook Form の管理下に置く
  return (
    <form onSubmit={handleSubmit(console.log)}>
      <input
        {...register("firstName", { required: true })}
        placeholder="First name"
      />

      <input
        {...register("lastName", { minLength: 2 })}
        placeholder="Last name"
      />

      <select {...register("category")}>
        <option value="">Select...</option>
        <option value="A">Category A</option>
        <option value="B">Category B</option>
      </select>

      <input type="submit" />
    </form>
  );
};
```

## useForm + propsでformMethodsを渡す パターン

これは、`input` 要素などが フォームコンポーネントの小要素にある場合に使えるパターン。

`useForm` で得られる `register` などのメソッドを子コンポーネントに渡す。
子コンポーネント内では、受け取った `register` などを使って、HTMLネイティブの`input` 要素などを React Hook Form の管理下に置く。

```tsx
import { useForm } from "react-hook-form";
import { UseFormRegister } from "react-hook-form";

export const MyUI = () => {
  const { register, handleSubmit } = useForm({
    defaultValues: {
      firstName: "",
      lastName: "",
      category: "",
    },
  });

  return (
    <form onSubmit={handleSubmit(console.log)}>
      <SubUI register={register} />
      <input type="submit" />
    </form>
  );
};

const SubUI = ({ register }) => {
  return (
    <>
      <input
        {...register("firstName", { required: true })}
        placeholder="First name"
      />

      <input
        {...register("lastName", { minLength: 2 })}
        placeholder="Last name"
      />

      <select {...register("category")}>
        <option value="">Select...</option>
        <option value="A">Category A</option>
        <option value="B">Category B</option>
      </select>
    </>
  );
};
```

## useForm + Controller パターン

子要素が制御コンポーネントの場合に使えるパターン。  
制御コンポーネントを React Hook Form の管理下に置くために、`Controller` コンポーネントを使う。  
ここで、制御コンポーネントとその逆の非制御コンポーネントについては、以下のようなものである:

- **非制御コンポーネント**: 入力の状態をDOMが管理しているコンポーネント。`register`を使用するコンポーネントはこれに当てはまる
- **制御コンポーネント**: useStateとonChangeで状態管理をしているコンポーネント。サードパーティのフォーム用コンポーネントは大体これに当てはまる(必ずしもそうとは限らないが)。

```tsx
import { useForm, Controller } from "react-hook-form";
import { useState } from "react";

export const MyUI = () => {
  const { handleSubmit, control } = useForm({
    defaultValues: {
      firstName: "",
      lastName: "",
    },
  });

  // Controller要素にcontrolを渡し、子コンポーネントはrenderに書く
  return (
    <form onSubmit={handleSubmit(console.log)}>
      <Controller
        name="firstName"
        control={control}
        rules={{ required: true }}
        render={({ field: { onChange, value } }) => (
          <ControlledComponent
            placeholder="First name"
            value={value}
            onChange={onChange}
          />
        )}
      />
      <Controller
        name="lastName"
        control={control}
        rules={{ required: true }}
        render={({ field: { onChange, value } }) => (
          <ControlledComponent
            placeholder="Last name"
            value={value}
            onChange={onChange}
          />
        )}
      />
      <input type="submit" />
    </form>
  );
};

const ControlledComponent = ({ placeholder, value, onChange }) => {
  const [localValue, setLocalValue] = useState(value);

  const handleChange = (e) => {
    const newValue = e.target.value;
    setLocalValue(newValue);
    // React Hook Form の onChange を呼び出す
    onChange(newValue);
  };

  return (
    <input
      value={localValue}
      onChange={handleChange}
      placeholder={placeholder}
    />
  );
};
```

## useForm + FormProvider + useFormContext パターン

これは、小要素が自前のコンポーネントの場合に使えるパターン。  
そして、`useForm`で得た関数を引数で渡すのではなくコンテキストで渡すようにするパターンである。  
`FormProvider`と`useFormContext`を使うことで、引数からではなく、`useFormContext`から、コンテキストに格納された値を呼び出すことができる。深いコンポーネント階層であってもフォームの状態にアクセスできる。

使い方の注意点として、`useFormContext`を使用するコンポーネントは必ず`FormProvider`の子孫である必要がある。

このパターンはpropsでの受け渡しを減らすことができコード記述量が減るメリットがある。  
しかし一方で、入力だけでなくコンテキストに依存して出力が決まるため、UIコンポーネントの参照透過性が失われ、挙動の把握が難しくなるのと、テストコードの書きやすさが損なわれる。

## useForm + FormProvider + useFormContext + Controller パターン

自前のコンポーネント(`useFormContext`を使えるコンポーネント)と制御コンポーネントが混在しているフォームで使えるパターン。

制御コンポーネントの部分は`Controller`を使い、自前のコンポーネントの部分には`useFormContext`,`FormProvider`を使う。

```tsx
import {
  useForm,
  FormProvider,
  Controller,
  useFormContext,
} from "react-hook-form";
import { useState } from "react";
import { ControlledComponent } from "some-controlled-component-library";

export const MyUI = () => {
  const formMethods = useForm({
    defaultValues: {
      firstName: "",
      lastName: "",
    },
  });

  // useFormから得た関数たちFormProviderに渡せば、子孫要素からuseFormContextで呼び出せる
  return (
    <FormProvider {...formMethods}>
      <form onSubmit={formMethods.handleSubmit(console.log)}>
        <SubUI placeholder="First name" name="firstName" />
        <Controller
          name="lastName"
          control={formMethods.control}
          rules={{ required: true }}
          render={({ field: { onChange, value } }) => (
            <ControlledComponent
              placeholder="Last name"
              value={value}
              onChange={onChange}
            />
          )}
        />
        <input type="submit" />
      </form>
    </FormProvider>
  );
};

// 制御コンポーネントでも、非制御コンポーネントでも構わない。
// 自前であり、useFormContextが使えればいい
const SubUI = ({ placeholder, name }) => {
  // useFormContext で、FormProviderが用意したコンテキストから関数(useFromで得た関数たち)を取得する
  const { register, watch, setValue } = useFormContext();
  const value = watch(name);
  const [localValue, setLocalValue] = useState(value);

  const handleChange = (e) => {
    const newValue = e.target.value;
    setLocalValue(newValue);
    setValue(name, newValue);
  };

  return (
    <input
      value={localValue}
      onChange={handleChange}
      placeholder={placeholder}
    />
  );
};
```

## useForm + useFieldArray パターン (動的フォームの場合)

入力要素が増減したり、並び変わったりするような動的なフォームを扱う場合は、`useFieldArray`を使う必要がある。

```tsx
import { useForm, useFieldArray } from "react-hook-form";

export const MyUI = () => {
  const { control, register } = useForm();
  const { fields, append, prepend, remove, swap, move, insert } = useFieldArray({
    control, // これはoptional。FormProviderを使う場合は control をセットする
    name: "test", // ユニークな名前を指定する必要がある。対応するフォーム要素のnameをつけるといい。
  });


  return (
    {fields.map((field, index) => (
      <input
        key={field.id}
        {...register(`test.${index}.value`)}
      />
    ))}
  );
}
```

## 様々な判断基準

### register を使うか control を使うか

子要素が input などのネイティブな非制御要素の場合は register を使う。  
子要素が UIライブラリによるコンポーネントなどの非標準の制御コンポーネントの場合は control を使う。  
controlの場合はControllerにname, controlとrenderを渡す感じのコード。

### propsで渡すかコンテキストで渡すか問題

原則はコンテキストで渡した方がいい。  
UIコンポーネントが、React Hook Form を使う場合とそうでない場合の両方で機能するように設計する場合は props で渡す設計になる。

#### 原則コンテキストで渡すことが良いとされる理由

props drillingを避けられる。  
必要な関数だけをコンテキストから取り出せるので、コードの変更が楽。(props増減のリレーを実装しなくていい）。  
フォームがある程度大きいor将来拡張されるのであればコンテキストを渡すようにした方がいい。  
実装の統一性の観点から、使い分けるのではなくコンテキストに統一した方がいい。

しかし参照透過性がなくなるデメリットも大きいので、どちらが良いかは意見が分かれるところだろう。
