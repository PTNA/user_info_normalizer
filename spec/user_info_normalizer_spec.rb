RSpec.describe UserInfoNormalizer do
  using UserInfoNormalizer
  it "has a version number" do
    expect(UserInfoNormalizer::VERSION).not_to be nil
  end

  it 'name_kana normalization' do
    expect('ピティナ 　ｼﾞﾛウ  '.normalize_name_kana).to eq 'ﾋﾟﾃｨﾅ ｼﾞﾛｳ'
    UserInfoNormalizer.configure do |config|
      config.name_kana_form = 'ピティナ　タロウ'
    end
    expect('ピティナ　 ｼﾞﾛウ'.normalize_name_kana).to eq 'ピティナ　ジロウ'
  end

  it 'zip_code normalization' do
    expect('12３ー-5747 '.normalize_zip_code).to eq '１２３－５７４７'
    UserInfoNormalizer.configure do |config|
      config.zip_code_form = '123-4567'
    end
    expect('12 a３ー5747 '.normalize_zip_code).to eq '123-5747'
  end

  it 'address normalization' do
    expect('東京豊島区巣鴨1丁目2ー-2コーポ203'.normalize_address).to eq '東京豊島区巣鴨１丁目２－２コーポ２０３'
  end
end
