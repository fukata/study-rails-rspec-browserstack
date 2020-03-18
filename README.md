# Rails 5.2.4 + RSpec 3.9 + System Spec + BrowserStack

※ 学習用

## これは何？

下記の連携を確認するためのリポジトリ

- Rails 5.2.4
- RSpec 3.9
- System Spec
- BrowserStack

BrowserStackを使ってSystem Specを実行したい。

## 課題

- BrowserStackの動画がテスト全体になってしまう。
  - コケたテストの動画が見やすいように各example毎に動画にしたい。

## 環境構築

事前にBrowserStackのユーザー登録を行い、ユーザー名とアクセスキーの取得が必要。

```bash
$ cd wiki
$ docker-compose up -d
```

## 設定

`wiki/spec/support/e2e.rb` を参照

## 実行方法

```bash
$ cd wiki
$ docker-compose exec app bundle exec rspec spec/system/
```
