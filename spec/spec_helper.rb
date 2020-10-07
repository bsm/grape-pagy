ENV['RACK_ENV'] ||= 'test'

require 'rspec'
require 'grape/pagy'
require 'rack/test'

Pagy::VARS[:items] = 10
Pagy::VARS[:max_items] = 20

class TestAPI < Grape::API
  helpers Grape::Pagy::Helpers

  params do
    use :pagination, items: 5
  end
  get '' do
    paginate (1..12).to_a, max_items: 6
  end

  resource :sub do
    params do
      use :pagination
    end
    get '/' do
      paginate (1..12).to_a
    end
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.raise_errors_for_deprecations!
end
