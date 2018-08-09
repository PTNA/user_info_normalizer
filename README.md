# UserInfoNormalizer

個人情報の形式を正規化するgemです。半角カナ変換など、ほぼ毎回ググってしまうような処理を代わりにやってくれます。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'user_info_normalizer', git: 'https://github.com/hiratamasato/user_info_normalizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install user_info_normalizer

## Usage
user_info_normalizerを使うところに以下のように記述します。

```ruby
using UserInfoNormalizer
```

今の所名前カナ、住所、郵便番号の形式をいい感じにしてくれます。

```ruby
'ピティナ　ｼﾞﾛウ'.normalize_name_kana
#=> 'ﾋﾟﾃｨﾅ ｼﾞﾛｳ'
'12３ー5747'.normalize_zip_code
#=> '１２３－５７４７'
'東京豊島区巣鴨1丁目2ー2コーポ203'.normalize_address
#=> '東京豊島区巣鴨１丁目２－２コーポ２０３'
```

config/initializers/user_info_normalizer.rbファイルに以下を記述することで
変換する形式を指定できます。（golangの"2006/1/2 15:04:05"みたいに具体的な形を与えます）

```ruby
UserInfoNormalizer.configure do |config|
  config.name_kana_form = 'ピティナ　タロウ'
  config.zip_code_form = '123-4567'
end

#...
 
'ピティナ　ｼﾞﾛウ'.normalize_name_kana
#=> 'ピティナ　ジロウ'
'12３ー5747'.normalize_zip_code
#=> '123-5747'
```

## TODO

- configureの設定項目の充実
- normalizerの項目充実
- その他たくさんある

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hiratamasato/user_info_normalizer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the UserInfoNormalizer project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/user_info_normalizer/blob/master/CODE_OF_CONDUCT.md).
