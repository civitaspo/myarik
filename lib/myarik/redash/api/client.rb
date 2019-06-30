module Myarik::Redash::Api
  class Client
    include Myarik::Logger::Helper
    extend Forwardable

    def_delegators :conn, :get, :post, :delete

    AVAILABLE_RESOURCES = {
      data_source_types: {path: '/api/data_sources/types', rest_methods: %i(get)},
      data_sources: {path: '/api/data_sources', rest_methods: %i(get post)},
      data_source: {path: '/api/data_sources/:id', rest_methods: %i(get post delete)},
      queries: {path: '/api/queries', rest_methods: %i(get_with_paging post)},
      query: {path: '/api/queries/:id', rest_methods: %i(get post delete)}
    }

    attr_reader :url, :api_key

    def initialize(url:, api_key:)
      @url = url
      @api_key = api_key

      AVAILABLE_RESOURCES.each do |name, props|
        define_resource(name: name, **props)
      end
    end

    private def conn
      # This connection does not have to be closed,
      # because this is just configurations.
      @conn ||= Faraday.new(url: url) do |f|
        f.headers[:content_type] = 'application/json'
        f.authorization :Key, api_key
        f.request :url_encoded
        f.request :retry
        f.request :json
        # TODO: This logging is so noisy, so will create a better logging strategy.
        # f.response :logger, logger
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    private def define_resource(name:, path:, rest_methods: [])
      define_singleton_method(name) do
        Resource.new(client: self, path: path, rest_methods: rest_methods)
      end
    end

  end
end
