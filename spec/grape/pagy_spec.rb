require 'spec_helper'

describe Grape::Pagy do
  include Rack::Test::Methods

  let(:app) { TestAPI }

  it 'paginates' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '1',
      'link'         => '<http://example.org/?page=1&items=5>; rel="first", ' \
                        '<http://example.org/?page=2&items=5>; rel="next", ' \
                        '<http://example.org/?page=3&items=5>; rel="last"',
      'page-items'   => '5',
      'total-count'  => '12',
      'total-pages'  => '3',
    )
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5]))
  end

  it 'accepts page and items parameters' do
    get '/?page=2&items=3'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '2',
      'page-items'   => '3',
      'total-count'  => '12',
      'total-pages'  => '4',
    )
    expect(last_response.body).to eq(%([4, 5, 6]))
  end

  it 'caps items' do
    get '/?items=10'
    expect(last_response.headers).to include('Page-Items' => '6')
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5, 6]))

    get '/?items=3'
    expect(last_response.headers).to include('Page-Items' => '3')
    expect(last_response.body).to eq(%([1, 2, 3]))
  end

  it 'ignores overflow' do
    get '/?page=99'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '99',
      'total-pages'  => '3',
    )
    expect(last_response.body).to eq(%([]))
  end

  it 'does not need options' do
    get '/no-opts'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'total-count' => '12',
      'total-pages' => '2',
    )
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
  end

  it 'allows countless mode' do
    get '/countless?page=2'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '2',
      'page-items'   => '3',
      'link'         => [
        %(<http://example.org/countless?page=1&items=3>; rel="first"),
        %(<http://example.org/countless?page=1&items=3>; rel="prev"),
        %(<http://example.org/countless?page=3&items=3>; rel="next"),
      ].join(', '),
    )
    expect(last_response.headers).not_to include(
      'total-count',
      'total-pages',
    )
    expect(last_response.body).to eq(%([4, 5, 6]))
  end

  it 'inherits helper' do
    get '/sub'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '1',
      'page-items'   => '10',
      'total-count'  => '13',
      'total-pages'  => '2',
    )
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))

    get '/sub?per_page=20'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'current-page' => '1',
      'page-items'   => '20',
      'total-count'  => '13',
      'total-pages'  => '1',
    )
  end
end
