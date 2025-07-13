---
title: "[Swift] 画面遷移アニメーション4種 (modalTransitionStyle)"
# image: "/images/tech-blog/slug/image.jpg"
description: "Swiftのpresentで画面遷移する際のアニメーションを4種類紹介する。coverVertical, crossDissolve, flipHorizontal, partialCurlの使い方を解説する。"
published: "2018-09-02"
updated: "2025-07-13"
category: "tech"
tags: ["ios", "swift"]
---

## 概要

present で画面遷移する際のアニメーションには、次の4種類が用意されている。

- `coverVertical`: 下から上 (デフォルト)
- `crossDissolve`: ふわっと登場
- `flipHorizontal`: くるっと反転
- `partialCurl`: ページめくり

![demo](/images/tech-blog/2018-swift-modal-transition-style/demo.webp)

## 実装方法

画面遷移先のコントローラーである`secondViewController`の`modalTransitionStyle`を設定することで、画面遷移（行きと戻りの両方）のアニメーションを設定できる。

```swift
/* どれかに設定する */
secondViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
// secondViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
// secondViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
// secondViewController.modalTransitionStyle = .UIModalTransitionStylepartialCurl
```

ちなみに、firstView &rArr; secondView へと画面遷移するためのコードは、

```swift
firstViewController.present(secondViewController, animated: true, completion: nil)
```

で、 secondView &rArr; firstView へと戻るには、

```swift
secondViewController.dismiss(animated: true, completion: nil)
```

とすればよい。

## サンプルコード

冒頭の動画のソースコード全体は次の通りだ。  
同じものを [GitHub](https://github.com/hahnah/til-swift/tree/modal-animation) にも置いておいた。

###### ViewController.swift

```swift
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let coverVerticalModalButton: UIButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height * 0, width: self.view.frame.width, height: self.view.bounds.height * 0.25))
        coverVerticalModalButton.setTitle("coverVertical", for: .normal)
        coverVerticalModalButton.setTitleColor(UIColor.white, for: .normal)
        coverVerticalModalButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        coverVerticalModalButton.backgroundColor = UIColor.red
        coverVerticalModalButton.addTarget(self, action: #selector(self.showSecondView(_:)), for: .touchUpInside)
        self.view.addSubview(coverVerticalModalButton)

        let crossDissolveModalButton: UIButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height * 0.25, width: self.view.frame.width, height: self.view.bounds.height * 0.25))
        crossDissolveModalButton.setTitle("crossDissolve", for: .normal)
        crossDissolveModalButton.setTitleColor(UIColor.white, for: .normal)
        crossDissolveModalButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        crossDissolveModalButton.backgroundColor = UIColor.orange
        crossDissolveModalButton.addTarget(self, action: #selector(self.showSecondView(_:)), for: .touchUpInside)
        self.view.addSubview(crossDissolveModalButton)

        let flipHorizontalButton: UIButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height * 0.5, width: self.view.frame.width, height: self.view.bounds.height * 0.25))
        flipHorizontalButton.setTitle("flipHorizontal", for: .normal)
        flipHorizontalButton.setTitleColor(UIColor.white, for: .normal)
        flipHorizontalButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        flipHorizontalButton.backgroundColor = UIColor.brown
        flipHorizontalButton.addTarget(self, action: #selector(self.showSecondView(_:)), for: .touchUpInside)
        self.view.addSubview(flipHorizontalButton)

        let partialCurlButton: UIButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.height * 0.75, width: self.view.frame.width, height: self.view.bounds.height * 0.25))
        partialCurlButton.setTitle("partialCurl", for: .normal)
        partialCurlButton.setTitleColor(UIColor.white, for: .normal)
        partialCurlButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        partialCurlButton.backgroundColor = UIColor.blue
        partialCurlButton.addTarget(self, action: #selector(self.showSecondView(_:)), for: .touchUpInside)
        self.view.addSubview(partialCurlButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func showSecondView(_ sender: UIButton) {
        let secondViewController = SecondViewController()
        secondViewController.view.backgroundColor = sender.backgroundColor

        switch sender.title(for: .normal) {
        case "coverVertical":
            secondViewController.modalTransitionStyle = .coverVertical
        case "crossDissolve":
            secondViewController.modalTransitionStyle = .crossDissolve
        case "flipHorizontal":
            secondViewController.modalTransitionStyle = .flipHorizontal
        case "partialCurl":
            secondViewController.modalTransitionStyle = .partialCurl
        default:
            secondViewController.modalTransitionStyle = .coverVertical
        }

        self.present(secondViewController, animated: true, completion: nil)
    }

}
```

###### SecondViewController.swift

```swift
import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeButton: UIButton = UIButton(frame: self.view.frame)
        closeButton.layer.position = self.view.layer.position
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        closeButton.backgroundColor = UIColor.clear
        closeButton.addTarget(self, action: #selector(self.close(_:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
```
