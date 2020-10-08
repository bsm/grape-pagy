ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'grape/pagy'
require 'rack/test'

Pagy::VARS[:items] = 10
Pagy::VARS[:max_items] = 20

class TestAPI < Grape::API
  helpers Grape::Pagy::Helpers

  params do
    use :pagy, items: 5, max_items: 6
  end
  get '' do
    pagy (1..12).to_a
  end

  resource :sub do
    params do
      use :pagy, items_param: :per_page
    end
    get '/' do
      pagy (1..12).to_a, count: 13
    end
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.raise_errors_for_deprecations!
end
