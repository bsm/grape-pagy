require 'spec_helper'

describe Grape::Pagy do
  include Rack::Test::Methods

  let(:app) { TestAPI }

  it 'paginates' do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'Current-Page' => '1',
      'Link'         => %(<http://example.org/?page=1>; rel="first", <http://example.org/?page=2>; rel="next", <http://example.org/?page=3>; rel="last"),
      'Page-Items'   => '5',
      'Total-Count'  => '12',
      'Total-Pages'  => '3',
    )
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5]))
  end

  it 'accepts page and items parameters' do
    get '/?page=2&items=3'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'Current-Page' => '2',
      'Page-Items'   => '3',
      'Total-Count'  => '12',
      'Total-Pages'  => '4',
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
      'Current-Page' => '99',
      'Total-Pages'  => '3',
    )
    expect(last_response.body).to eq(%([]))
  end

  it 'allows countless mode' do
    get '/countless?page=2'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'Current-Page' => '2',
      'Page-Items'   => '3',
      'Link'         => [
        %(<http://example.org/countless?page=1>; rel="first"),
        %(<http://example.org/countless?page=1>; rel="prev"),
        %(<http://example.org/countless?page=3>; rel="next"),
      ].join(', '),
    )
    expect(last_response.headers).not_to include(
      'Total-Count',
      'Total-Pages',
    )
    expect(last_response.body).to eq(%([4, 5, 6]))
  end

  it 'inherits helper' do
    get '/sub'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'Current-Page' => '1',
      'Page-Items'   => '10',
      'Total-Count'  => '13',
      'Total-Pages'  => '2',
    )
    expect(last_response.body).to eq(%([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))

    get '/sub?per_page=20'
    expect(last_response.status).to eq(200)
    expect(last_response.headers).to include(
      'Current-Page' => '1',
      'Page-Items'   => '20',
      'Total-Count'  => '13',
      'Total-Pages'  => '1',
    )
  end
end
