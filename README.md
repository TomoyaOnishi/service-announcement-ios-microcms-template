# service-announcement-ios-microcms-template

microCMSを使ったiOSアプリ向けのお知らせ一覧のテンプレートです。

ページネーション、カテゴリによる絞り込みも可能です。

---
microCMSはヘッドレスCMSと呼ばれ、コンテンツを入稿、編集、管理することができるプラットフォームです。入稿されたコンテンツはAPIで簡単に取得できます。

APIからコンテンツを取得できるので、アプリは好みのUIでコンテンツを表示することだけに専念できます。

---

# Get Started
`Defines.swift`に定義してある2つの変数を自分のサービスのものに変更してください。
その後、`@available`を削除するとビルドできるようになります。

```swift
@available(*, unavailable, message: "Replace API Key with your API Key, and Remove @available")
let microCMSAPIKey = (key: "X-MICROCMS-API-KEY", value: "xxxxxxxxxxxxxxxxxx")

@available(*, unavailable, message: "Replace this with your service domain, and Remove @available")
let microCMSServiceDomain = "xxxxxx"
```


# iOS

| お知らせ一覧 | カテゴリ選択 | フィルタ時表示 | 
| --- | --- | --- | 
| <img width=320 src="https://github.com/TomoyaOnishi/service-announcement-ios-microcms-template/assets/2742732/d6ef1cb5-f518-4868-a23c-5337f6d2683c" /> | <img width=320 src="https://github.com/TomoyaOnishi/service-announcement-ios-microcms-template/assets/2742732/ef865049-1dc8-4d4a-8a51-755540845f43" /> | <img width=320 src="https://github.com/TomoyaOnishi/service-announcement-ios-microcms-template/assets/2742732/905273b8-eca2-451b-a3eb-5b3d18ba39cd" /> |


# macOS

<img width="1061" alt="Screenshot 2023-05-17 at 16 14 51" src="https://github.com/TomoyaOnishi/service-announcement-ios-microcms-template/assets/2742732/f238d49a-481f-481c-be9d-3989ba8fd191">
