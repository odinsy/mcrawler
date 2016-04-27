FactoryGirl.define do
  factory :seo_params, class: MetricsCrawler::SeoParams do
    url = 'https://www.facebook.com/'
    initialize_with { new(url) }
  end
end
