FactoryGirl.define do
  factory :seo_params_with_proxy, class: MetricsCrawler::SeoParams do
    url = 'https://www.facebook.com/'
    proxy = 'http://wls-01.co.spb.ru:3128'
    initialize_with { new(url, proxy) }
  end
end
