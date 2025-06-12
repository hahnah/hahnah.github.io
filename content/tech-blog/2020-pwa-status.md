---
title: "モバイルPWAのステータス in 2020"
# image: "/images/tech-blog/slug/image.jpg"
description: "2020年時点でProgressive Web Apps (PWA) がどのような機能をサポートしているか、AndroidとiOSそれぞれについて調査した。"
published: "2020-11-15"
updated: "2025-06-13"
category: "tech"
tags: ["frontend", "pwa", "ios", "android"]
---

## 調査目的

Webサービスを作っていると、ユーザー体験を良くするためにプッシュ通知などを実装できたらいいのになあ、なんて思うことがある。

それって[PWA](https://web.dev/progressive-web-apps/)の技術で実現できるんだっけ？
できるならやりたいし、できないならネイティブのアプリ開発も視野に入るな。
といった具合だ。

PWAでどんな機能が実現できるのか、2020年11月時点での情報を知りたい。

## PWAのステータス

Android Chrome, iOS Safari で何の機能が実現できるか調査したところ、以下のようになった。
(ブラウザーのバージョンは2020年11月時点での最新バージョンとする)

| 機能                           | PWA in Android | PWA in iOS | 備考                                                                                            |
| ------------------------------ | -------------- | ---------- | ----------------------------------------------------------------------------------------------- |
| ホーム画面追加                 | &#x2705;       | &#x2705;   |
| 全画面表示                     | &#x2705;       | &#x2705;   |
| オフライン動作                 | &#x2705;       | &#x2705;   | ただしiOSではオフラインデータを50Mbしか保存できないという厳しい制限がある                       |
| バックグランドデータ同期       | &#x2705;       | &#x2716;   |
| プッシュ通知                   | &#x2705;       | &#x2716;   | https://developer.mozilla.org/ja/docs/Web/API/Push_API                                          |
| 通知                           | &#x2705;       | &#x2716;   | プッシュ通知でない、ただの通知。https://developer.mozilla.org/ja/docs/Web/API/Notifications_API |
| バッジ                         | &#x2705;       | &#x2716;   |
| カメラ                         | &#x2705;       | &#x2705;   |
| マイク                         | &#x2705;       | &#x2705;   |
| オーディオ出力                 | &#x2705;       | &#x2705;   |
| 音声認識                       | &#x2705;       | &#x2705;   |
| 音声合成                       | &#x2705;       | &#x2705;   |
| スピーチ                       | &#x2705;       | &#x2705;   |
| 位置情報                       | &#x2705;       | &#x2705;   | ただしiOSではバックグラウンド時のみ位置情報は取得不可                                           |
| 方位・加速度・ジャイロスコープ | &#x2705;       | &#x2705;   |
| Bluetooth                      | &#x2705;       | &#x2716;   |
| NFC                            | &#x2705;       | &#x2716;   |
| 生体認証                       | &#x2705;       | &#x2705;   |
| 支払い                         | &#x2705;       | &#x2705;   |
| プレイストアで公開             | &#x2705;       | &#x2716;   | Google Play StoreにはPWAを公開できる                                                            |
| Share機能(一部)                | &#x2705;       | &#x2705;   | https://developer.mozilla.org/ja/docs/Web/API/Navigator/share                                   |

※漏れている機能も多分にあると思う

## Safariに実装されない機能たち

上の表を見るとiOS Safariでは利用できない機能が多々あるのが目立つが、AppleはSafariへの機能追加にかなり慎重なようだ。
2020年7月には、フィンガープリンティングの懸念から、いくつかのWebAPIの実装を拒否するという[アナウンス](https://webkit.org/tracking-prevention/)がされている。
BluetoothやNFC、バックグラウンドでの位置情報取得などもここで挙げられている。

> Finally, if we find that features and web APIs increase fingerprintability and offer no safe way to protect our users, we will not implement them until we or others have found a good way to reduce that fingerprintability.

## おわりに

何年か前にPWAを知ったのだが、当時と比べるとiOSでもできることが増えたなという印象。
WebでもApple Payでの支払いができるようになってるのは驚いた。
ただ、プッシュ通知という最も切望されてそうな機能はまだ対応されておらず残念。

それと、この記事を書く中で、利用可能な機能が一覧表示される便利なサイトを見つけた。
[WHAT WEB CAN DO TODAY?](https://whatwebcando.today/)

このサイトにアクセスすると、現在利用しているブラウザーでどの機能が使えるのか/使えないのかがひと目で分かる。
Android Chrome, iOS Safari でアクセスして見比べてみると良さそう。

## 参考資料

- [Safari on iOS 14 and iPadOS 14 for PWA and Web Developers－firt.dev](https://medium.com/@firt/safari-on-ios-14-and-ipados-14-for-pwa-and-web-developers-firt-dev-afb9f6489aef)
- [What’s new on iOS 12.2 for Progressive Web Apps](https://medium.com/@firt/whats-new-on-ios-12-2-for-progressive-web-apps-75c348f8e945)
- [Progressive Web Apps on iOS are here &#x1f680;](https://medium.com/@firt/progressive-web-apps-on-ios-are-here-d00430dee3a7)
- [WHAT WEB CAN DO TODAY?](https://whatwebcando.today/)
- [Tracking Prevention in WebKit](https://webkit.org/tracking-prevention/)
