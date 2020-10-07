require 'grape'
require 'pagy'
require 'pagy/extras/arel'
require 'pagy/extras/array'
require 'pagy/extras/headers'
require 'pagy/extras/items'
require 'pagy/extras/overflow'

module Grape
  module Pagy
    Pager = Struct.new :request, :params do
      include ::Pagy::Backend

      def paginate(collection, via: nil, **opts, &block)
        pagy_with_items(opts)
        via ||= if collection.respond_to?(:arel_table)
                  :arel
                elsif collection.is_a?(Array)
                  :array
                end

        method = [:pagy, via].compact.join('_')
        page, scope = send(method, collection, **opts)

        pagy_headers(page).each(&block)
        scope
      end
    end

    module Helpers
      extend Grape::API::Helpers

      params :pagination do |items: ::Pagy::VARS[:items]|
        optional ::Pagy::VARS[:page_param], type: Integer, default: 1, desc: 'Page offset to fetch.'
        optional ::Pagy::VARS[:items_param], type: Integer, default: items, desc: 'Number of items to return per page.'
      end

      def paginate(collection, via: nil, **opts)
        Pager.new(request, params).paginate(collection, via: via, **opts) do |key, value|
          header key, value
        end
      end
    end
  end
end
