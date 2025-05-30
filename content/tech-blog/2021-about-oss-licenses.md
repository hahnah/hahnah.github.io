---
title: "OSSライセンスについて知っていること"
# image: "/images/tech-blog/slug/image.jpg"
description: "OSSライセンスはソフトウェアエンジニアなら知っておかなければならないことの一つだ。OSSライセンスの種類や、ライセンスなしに公開されたソースコードの扱いについて解説する。"
published: "2021-03-31"
updated: "2025-05-30"
category: "tech"
tags: ["oss-license"]
---

※ この記事は一介のソフトウェアエンジニアの認識を記したものであり、著者は知的財産権の専門家ではありません。記事の内容は不正確な情報を含む可能性がありますので、参考程度に留めてください。

## OSSライセンスとは

OSS (Open Source Software) の利用許諾書のことであり、これにはOSSの利用条件や頒布条件などがライセンサー(著作権者)により記されている。OSSのユーザーはこれに記された条件に従うことで、ライセンサーから利用許諾を得る手続きをせずともそのOSSを利用することができる。別の言い方をすると、OSSを利用・頒布・被頒布等した時点でライセンスに同意したものとみなされる。

## OSSライセンスの例

例えば React v17.0.0 というOSSのライセンスは [https://github.com/facebook/react/blob/v17.0.0/LICENSE](https://github.com/facebook/react/blob/v17.0.0/LICENSE) で確認できるように、MIT License と呼ばれるライセンスである。

> MIT License
>
> Copyright (c) Facebook, Inc. and its affiliates.
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to deal
> in the Software without restriction, including without limitation the rights
> to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
> copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all
> copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
> OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> SOFTWARE.

ざっくりと、以下のようなことが書かれている:

- 著作権者の情報 (上の例にはないが、西暦何年の著作物かも合わせて書かれることが多い)
- 利用者が条件に従う限り、無制限に無償で利用を許可する
- (条件) 利用にあたり著作権表示をすること
- (条件) 作者・著作権者は、このソフトウェアに起因する問題のいかなる責任も負わないし、何も保証しない

ところでOSSライセンスにはどんなものが存在するのだろうか？
大きく３つのタイプに分類できる。

- コピーレフト型: そのOSSを組み込んだソフトウェアに対し、ソースコードの開示義務に関するライセンス条件を持つ。また、準コピーレフト型に説明するライセンス条件も持つ。
- 準コピーレフト型: そのOSSを改変している場合の改変部分のソースコード開示義務に関するライセンス条件を持つ。
- 非コピーレフト型: ソースコード開示義務に関するライセンス条件を持たない。

傾向としては、ライセンス条件の厳しさ順に
コピーレフト型 > 準コピーレフト型 > 非コピーレフト
となっていると思っていいだろう。（ソースコード開示義務以外の尺度もあるので一概には言えないが。）

先術の MIT Lisence は非コピーレフト型のライセンスである。

他のOSSライセンスも軽く紹介しよう。
Open Source Initiative が 'Popular' としているライセンス を下表に列挙する:
(リストは [https://opensource.org/licenses/](https://opensource.org/licenses/) より)

| ライセンス名                                                                                                                               | 略称         | 分類             |
| ------------------------------------------------------------------------------------------------------------------------------------------ | ------------ | ---------------- |
| [Apache License, Version 2.0](https://opensource.org/licenses/Apache-2.0)                                                                  | Apache-2.0   | 非コピーレフト型 |
| [The 3-Clause BSD License](https://opensource.org/licenses/BSD-3-Clause) (過去には New BSD License や Modified BSD License とも呼ばれた)   | BSD-3-Clause | 非コピーレフト型 |
| [The 2-Clause BSD License](https://opensource.org/licenses/BSD-2-Clause) (過去には Simplified BSD License や FreeBSD License とも呼ばれた) | BSD-2-Clause | 非コピーレフト型 |
| [GNU General Public License version 2](https://opensource.org/licenses/GPL-2.0)                                                            | GPL-2.0      | コピーレフト型   |
| [GNU General Public License version 3](https://opensource.org/licenses/GPL-3.0)                                                            | GPL-3.0      | コピーレフト型   |
| [GNU Lesser General Public License version 2.1](https://opensource.org/licenses/LGPL-2.1)                                                  | LGPL-2.1     | コピーレフト型   |
| [GNU Lesser General Public License version 3](https://opensource.org/licenses/LGPL-3.0)                                                    | LGPL-3.0     | コピーレフト型   |
| [The MIT License](https://opensource.org/licenses/MIT)                                                                                     | MIT          | 非コピーレフト型 |
| [Mozilla Public License 2.0](https://opensource.org/licenses/MPL-2.0)                                                                      | MPL-2.0      | 準コピーレフト型 |
| [Common Development and Distribution License 1.0](https://opensource.org/licenses/CDDL-1.0)                                                | CDDL-1.0     | 準コピーレフト型 |
| [Eclipse Public License version 2.0](https://opensource.org/licenses/EPL-2.0)                                                              | EPL-2.0      | 準コピーレフト型 |

## ライセンスなしに公開されたソースコードの扱い

ライセンスに関する記載がない場合、ユーザーはそのソースコードを私的利用の範囲を超えて利用するために著作権者から許諾を得る必要がある。  
許諾なしに利用した場合は著作権法上の問題に発展しかねないので、やってはならない。

また、自身でOSSをリリースしようとする際にはライセンスを定めることが必須となる。（そもそも、ライセンスの記載がない場合それは定義上OSSとは呼ばれないのだが。）  
あなたが有用なソフトウェアを開発し、色々な人に自由に使ってもらいたいという思いでソースコードを公開したしたとしよう。ただし、そこにはライセンスが記載されていない。  
この場合、利用したいと思った人がいたとしても著作権法上の由々しき事態に繋がりうるので利用できないのだ。  
もしくは、あなたに利用許諾を得ようとコンタクトがあるかもしれないが、それは双方にとってやや面倒だろう。  
あるいは、そういった問題を無視して勝手に利用するかもしれない。

OSSライセンスを用意しておくと、あなたにとってもユーザーにとっても面倒なことにならずに済む。  
特に理由やこだわりがないなら、MIT License や Apatch License version 2.0 などのメジャーで条件の緩いライセンスにしておくといいだろう。  
ただし、あなたのOSSが別のOSSを組み込んでいる場合はそのOSSライセンスと両立性のある（つまり矛盾するライセンス条件がないような）ライセンスにしなければならないことに注意したい。

### ライセンスの両立性

[ライセンス両立性](https://www.gnu.org/licenses/gpl-faq.html#WhatIsCompatible)の問題はGPL系ライセンスのOSSで起こりがちだ。

例えばGPL-2.0/3.0 と他の主なライセンスとの両立性は以下のようになる。

|              | GPL-2.0 との両立性 | GPL-3.0 との両立性 |
| ------------ | ------------------ | ------------------ |
| MIT          | &#10003;           | &#10003;           |
| Apache-2.0   |                    | &#10003;           |
| BSD-4-Clause |                    |
| BSD-3-Clause | &#10003;           | &#10003;           |
| BSD-2-Clause | &#10003;           | &#10003;           |
| GPL-2.0      | &#10003;           |
| GPL-3.0      |                    | &#10003;           |
| LGPL-2.1     | &#10003;           |
| LGPL-3.0     |                    | &#10003;           |
| MPL-2.0      | &#10003;           | &#10003;           |

ただし、OSSによってはGPL-2.0やGPL-3.0のライセンスとしていても、そのライセンス条件の一部を緩和する旨を著作権者が例外事項として明記している場合もある。その場合は上表のとおりではなく、両立するようになることもある。

## OSSライセンスがソースコード開示義務の条件を持つ場合は要注意

OSSライセンスの中には、そのOSSを組み込んだソフトウェアに対してソースコードを開示することや商用利用を制限するなどの条件を課すものが多く存在する。  
特にGPL系のライセンスをはじめ、いくつかの(決して少なくない)OSSライセンスでは、そのOSSを頒布している場合に組み込んでいるソフトウェアのソースコードの開示義務を課している。

これにより具体的にどのような困った事態になるのか。  
例えばGPL系ライセンスのOSSをそのままバンドルしたアプリーケーションをあなたが開発し、それがユーザーに使われているとしよう。  
この場合、あなたはGPL系ライセンスの条件に基づき、アプリケーションのソースコードをユーザーに開示しなければならない（もしユーザーが求めなければ結果的に開示せずに済むこともあるが）。そのために、あなたは以下のような方法をとることになる：

- ユーザーからの要請があった際にアプリケーションのソースコードをユーザーに提供する
- (要請の有無に関わらず初めから) アプリケーションのソースコードをユーザーに提供する
- アプリケーションのソースコードをOSSとして公開し、ユーザーが入手できるようにする

あなたのアプリケーションが商用であったりソースコードに機密性があったとすれば、あなたにとってまずい状況になりうる。ユーザーは入手したソースコードを利用し、あなたと同じビジネスを初められるかもしれない。ユーザーは入手したソースコードを公開し、あなたのアプリケーションにある技術的な優位性を誰もが獲得できる状況を作り上げるあげるかもしれない。少なくとも、あなたのソフトウェアの機密性を守ることはできない。

開示義務で困った事態とならないために、利用するOSSを頒布することになるのかどうか、意識出来ておいた方がいいだろう。  
また、利用するOSSを選定する時点で開示義務の条件を持つようなライセンスのものをなるべく選ばないようにするのも一つの手だ。

## Webサービスにおいて頒布となる例/ならない例

OSSの頒布にあたるかどうかは、あなたのソースコードの開示義務に関わってくるので重要なファクターだ。  
しかしその判断方法は少しややこしい。

私がWebエンジニアなので、ここではWebサービスのケースについて、頒布にあたるのかどうかを考えてみる。

**サーバーサイドで動作するソフトウェアにOSSを組み込んでいる場合 --**

ソフトウェアはサーバー上で動いておりユーザーには届かない。つまり頒布していない。

ただし、オンプレミスのサーバーの場合は話が変わってくる。  
オンプレミスの場合サーバーの所有者はユーザーであり、サーバー上で動いているそのソフトウェアは、あなたがユーザーに提供したことになる。  
そのOSSがスクリプト言語で作られたライブラリであるなら、OSSがそのまま(あるいは改変されて)頒布されていることになる可能性が高い。  
OSSがコンパイル言語で記述されていて、それをコンパイルして出来た成果物をあなたのソフトウェアで利用している場合は、OSSを頒布していないと言えるだろう。

**クライアントサイド（Webブラウザー）で動作するソフトウェアにOSSを組み込んでいる場合 --**

この場合は特に注意が必要になる。  
ブラウザー上で動作するソフトウェアということは JavaScript で記述されているわけだが、これは実行形式でもソースコードでもある。  
ユーザーのブラウザーに配信されるJavaScriptのコードには、JavaScriptで記述されたOSSがそのまま（あるいは改変されて）存在しているだろう。つまりOSSを頒布していることになる。  
ただしこれは、そのOSSがJavaScriptで書かれている場合だ。

もしOSSがTypeScriptで書かれていたなら、あなたはそれをトランスパイルして出来たJavaScriptのコード(成果物)をユーザーに配信していることになる。この場合はOSSを頒布していることにはならないだろう。

## おわりに

OSSライセンスには記述の明瞭さが不十分なものも多く、専門家の間でも解釈がわかれる。OSSライセンス絡みの裁判の判例もおそらく十分にないのではないだろうか。  
たとえ業務経験があったとしても多少学んだ程度の人間では正確に把握することは困難なので、実際にこの分野の知識が必要になった際には専門家に頼るべきだ。  
会社であれば知財部門や法務に相談することになるだろう。

ただ、あなたがソフトウェアエンジニアやプロジェクトマネージャーであるなら、OSSライセンスについて概要を知っておくだけでも、多くの問題を回避できるだろう。

OSSライセンスを恐れ過ぎず、どんどんOSSを利用して開発しよう！

また、ソフトウェアのソースコードを公開する場合はライセンス表記をお忘れなく！

## 参考

- [Open Source Initiative](https://opensource.org/)
- [さまざまなライセンスとそれらについての解説 -- GNUオペレーティング・システム](https://www.gnu.org/licenses/license-list.ja.html)
- [開発では3つのOSSライセンス分類で対応を判断する -- 技術系管理職の基礎知識](https://emgr.jp/3-oss-license-categories)
- OSSライセンスの教科書 初版 (技術評論社、著：上田理)
