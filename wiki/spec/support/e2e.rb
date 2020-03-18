require 'browserstack/local'

# E2Eテスト用の設定
#
# 環境変数一覧
# TEST_BROWSER: テストするブラウザ名(browserstack,headless_chrome)
# BROWSERSTACK_CONFIG_NAME: BrowserStack用の設定ファイル名 (パス: config/${name}.config.yml)
# BROWSERSTACK_USERNAME: BrowserStack用のユーザー名 (管理画面から取得可能)
# BROWSERSTACK_ACCESS_KEY: BrowserStack用のアクセスキー (管理画面から取得可能)
# BROWSERSTACK_NAME: テスト名
# BROWSERSTACK_BROWSER_ID: 設定ファイル内のbrowser_capsのインデックス

Rails.logger.info("E2E Settings Start")

# テストを行うブラウザを環境変数「TEST_BROWSER」の値を元に設定する
# デフォルトは「Headless Chrome」
# browserstack: BrowserStack
browser = ENV['TEST_BROWSER'].to_s.downcase
Rails.logger.info("browser=#{browser}")
case browser
when 'browserstack'
  Rails.logger.info("Use BrowserStack")

  # monkey patch to avoid reset sessions
  class Capybara::Selenium::Driver < Capybara::Driver::Base
    def reset!
      if @browser
        @browser.navigate.to('about:blank')
      end
    end
  end

  # BrowserStack用の設定ファイル読み込み、capabilitiesの設定
  config_name = ENV['BROWSERSTACK_CONFIG_NAME'] || 'browserstack'
  bs_config = YAML.load(File.read(Rails.root.join("config", "#{config_name}.config.yml").to_s))
  bs_config['user'] = ENV['BROWSERSTACK_USERNAME'] || bs_config['user']
  bs_config['key'] = ENV['BROWSERSTACK_ACCESS_KEY'] || bs_config['key']

  browser_id = (ENV['BROWSERSTACK_BROWSER_ID'] || 0).to_i
  caps = bs_config['common_caps'].merge(bs_config['browser_caps'][browser_id])
  caps['name'] = ENV['BROWSERSTACK_NAME'] || caps['name'] || 'Rspec Sample Test'

  enable_local = caps["browserstack.local"] && caps["browserstack.local"].to_s == "true"
  if enable_local
    caps["browserstack.local"] = true
  end

  # Code to start browserstack local before start of test
  bs_local = nil
  if enable_local
    bs_local = BrowserStack::Local.new
    bs_local_args = { "key" => bs_config['key'], "forcelocal" => true }
    bs_local.start(bs_local_args)
  end

  at_exit do
    bs_local.stop unless bs_local.nil?
  end

  RSpec.configure do |config|
    config.before(:example, type: :system) do |example|
      driven_by :selenium, using: :remote, options: {
        url: "http://#{bs_config['user']}:#{bs_config['key']}@#{bs_config['server']}/wd/hub",
        desired_capabilities: caps
      }
    end
  end

else
  Rails.logger.info("Use Headless Chrome")

  RSpec.configure do |config|
    config.before(:example, type: :system) do |example|
      driven_by :selenium, using: :headless_chrome, screen_size: [1280, 800], options: { args: ["headless", "disable-gpu", "no-sandbox", { "lang" => 'ja-JP' }] }
    end
  end
end

Rails.logger.info("E2E Settings End")