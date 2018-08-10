require "user_info_normalizer/version"
require "user_info_normalizer/configuration"
require 'nkf'

module UserInfoNormalizer
  # ハイフンは'－'.ord.to_s(16) => ff0d に統一
  HYPHEN_REGEXP = "\u002D|\u30FC|\u2010|\u2011|\u2013|\u2014|\u2015|\u2212|\uFF70|\uFF0d"

  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= UserInfoNormalizer::Configuration.new
    end
  end

  refine String do
    def normalize_name_kana
      case UserInfoNormalizer::configuration.name_kana_form
      when 'ピティナ　タロウ'
        self.tr(' ', '　').squeeze('　').to_katakana
      else
        # default: 'ﾋﾟﾃｨﾅ ﾀﾛｳ'
        self.tr('　', ' ').squeeze(' ').to_hankaku_katakana
      end.strip
    end

    def normalize_address
      # 数字の前後で長音などはありえないのでハイフンに直す, 数字も全角に
      self.tr('0-9', '０-９')
          .gsub(/([０-９])(#{UserInfoNormalizer::HYPHEN_REGEXP})+/, '\1－')
          .squeeze('－')
          .strip
    end

    def normalize_zip_code
      case UserInfoNormalizer::configuration.zip_code_form
      when '123-4567'
        str = self.tr('０-９', '0-9')
            .gsub(/#{UserInfoNormalizer::HYPHEN_REGEXP}/, '-')
            .squeeze('-')
            .delete("^0-9|-")
        if str.length == 7 && str =~ /\A[0-9]+\z/
          # 数字７文字だった場合
          str.insert(3, '-')
        end
        str
      else
        # default: '１２３－４５６７'
        str = self.tr('0-9', '０-９')
            .gsub(/#{UserInfoNormalizer::HYPHEN_REGEXP}/, '－')
            .squeeze('－')
            .delete("^０-９|－")
        if str.length == 7 && str =~ /\A[０-９]+\z/
          # 全角数字７文字だった場合
          str.insert(3, '－')
        end
        str
      end.strip
    end

    def normalize_tel
      case UserInfoNormalizer::configuration.tel_form
      when '012-3456-7890'
        self.tr('０-９', '0-9').tr('　', ' ')
                  .gsub(/#{UserInfoNormalizer::HYPHEN_REGEXP}/, '-')
                  .squeeze('-')
                  .delete("^0-9|-| ").strip.tr(' ', '-')
      else
        # default: '１２３－４５６７'
        self.tr('0-9', '０-９').tr(' ', '　')
                  .gsub(/#{UserInfoNormalizer::HYPHEN_REGEXP}/, '－')
                  .squeeze('－')
                  .delete("^０-９|－|　").strip.tr('　', '－')
      end
    end

    def to_hiragana
      NKF.nkf('-w --hiragana', self)
    end

    def to_katakana
      NKF.nkf('-w --katakana', self)
    end

    # ひらがな、カタカナ混じりのものをすべて半角カナに変換
    def to_hankaku_katakana
      NKF.nkf('-w -Z4', to_katakana)
    end
  end

  refine NilClass do
    def normalize_name_kana; end
    def normalize_zip_code; end
    def normalize_address; end
  end

end
