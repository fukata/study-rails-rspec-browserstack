# Rails 5.2.4 + RSpec 3.9 + System Spec + BrowserStack

**※ 学習用**

## これは何？

下記の連携を確認するためのリポジトリ

- Rails 5.2.4
- RSpec 3.9
- System Spec
- BrowserStack
- Selenium Grid 3.141.59

BrowserStackを使ってSystem Specを実行したい。

## 課題

- BrowserStackの動画がテスト全体になってしまう。
  - コケたテストの動画が見やすいように各example毎に動画にしたい。

## サンプル動画

- [IE11(Win10) on BrowserStack](https://github.com/fukata/study-rails-rspec-browserstack/raw/master/assets/video-1c337e929893ab972fa5a43743f2fb3caeb8c978.mp4)
- [IE11(Win10) on Windows 10](https://github.com/fukata/study-rails-rspec-browserstack/raw/master/assets/video-vb5b642c4bfa7b10809dd5ba1ab6f166b.mp4)

## 環境構築

BrowserStackを使う場合は、事前にのユーザー登録を行い、ユーザー名とアクセスキーの取得が必要。

```bash
$ cd wiki
$ docker-compose up -d
```

## 設定

使用可能な環境変数一覧

- TEST_BROWSER: テストするブラウザ名(browserstack,selenium-grid,headless_chrome)
- BROWSERSTACK_CONFIG_NAME: BrowserStack用の設定ファイル名 (パス: config/${name}.config.yml)
- BROWSERSTACK_USERNAME: BrowserStack用のユーザー名 (管理画面から取得可能)
- BROWSERSTACK_ACCESS_KEY: BrowserStack用のアクセスキー (管理画面から取得可能)
- BROWSERSTACK_NAME: テスト名
- BROWSERSTACK_BROWSER_ID: 設定ファイル内のbrowser_capsのインデックス
- SELENIUM_HUB_HOST: selenium-gridを使ってテストする場合のhubのホスト名
- SELENIUM_HUB_PORT: selenium-gridを使ってテストする場合のhubのポート番号

詳細は `wiki/spec/support/e2e.rb` を参照

## Selenium Grid

IE11を手元のマシンで動かしたい場合に使用する。

ホストマシンがWindowsの場合に限る。

下記のページから `Selenium Server (Grid)` と `The Internet Explorer Driver Server` を適当な場所にダウンロードする。（今回は、 `C:\` )

https://www.selenium.dev/downloads/

### HubとNodeを起動しておく

- Hub
    ```
    java -jar .\selenium-server-standalone-3.141.59.jar -role hub -debug
    ```
- Node
    ```
    java -jar .\selenium-server-standalone-3.141.59.jar -role node -nodeConfig node.json -debug
    ```

### node.json

```json
{
  "capabilities": [
    {
      "browserName": "internet explorer",
      "version": "11",
      "maxInstances": 5,
      "platform": "WINDOWS",
      "webdriver.ie.driver": "C:/IEDriverServer.exe"
    }
  ],
  "_comment" : "Configuration for Node",
  "cleanUpCycle": 2000,
  "timeout": 30000,
  "port": 5555,
  "host": "127.0.0.1",
  "register": true,
  "hubPort": 4444,
  "maxSession": 5
}
```
