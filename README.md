# Grape::Pagy

[![Build Status](https://travis-ci.org/bsm/grape-pagy.png?branch=master)](https://travis-ci.org/bsm/grape-pagy)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

[Pagy](https://github.com/ddnexus/pagy) pagination for [grape](https://github.com/ruby-grape/grape) API framework.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'grape-pagy'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install grape-pagy
```

## Usage

```ruby
class MyApi < Grape::API
  # Include helpers in your API.
  helpers Grape::Pagy::Helpers

  resource :posts do
    desc 'Return a list of posts.'
    params do
      # This will add two optional params: :page and :items.
      # The parameter names can be globally configured by adjusting
      # global Pagy::VARS[:page_param] and Pagy::VARS[:item_param]
      # settings.
      use :pagination
    end
    get do
      posts = Post.all.order(created_at: :desc)
      paginate(posts)
    end
  end

  resource :strings do
    params do
      # Override the number items returned, defaults to Pagy::VARS[:items].
      use :pagination, items: 2
    end
    get do
      words = %w[an array of words]
      # This supports array as well as relations.
      # Allows to override global Pagy::VARS settings.
      paginate(words, max_items: )
    end
  end
end
```

Example request:

```shell
curl -si http://localhost:8080/api/posts?page=3&items=5
```

The response will be paginated and also will include the following headers:

```
Current-Page: 3
Page-Items: 5
Total-Count: 22
Total-Pages: 5
Link: <http://localhost:8080/api/posts?page=1&items=5>; rel="first", <http://localhost:8080/api/posts?page=4&items=5>; rel="next", <http://localhost:8080/api/posts?page=2&items=5>; rel="prev", <http://localhost:8080/api/posts?page=5&items=5>; rel="last"),
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bsm/grape-pagy.
