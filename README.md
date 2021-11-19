# Grape::Pagy

[![Ruby](https://github.com/bsm/grape-pagy/actions/workflows/ruby.yml/badge.svg)](https://github.com/bsm/grape-pagy/actions/workflows/ruby.yml)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

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
      use :pagy
    end
    get do
      posts = Post.all.order(created_at: :desc)
      pagy(posts)
    end
  end

  resource :strings do
    desc 'Supports arrays as well as relations.'
    params do
      # Override defaults by setting Pagy::DEFAULT or by passing options.
      use :pagy,
          items_param: :per_page, # Accept per_page=N param to limit items.
          items: 2,               # If per_page param is blank, default to 2.
          max_items: 10           # Restrict per_page to maximum 10.
    end
    get do
      words = %w[this is a plain array of words]
      pagy(words)
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
