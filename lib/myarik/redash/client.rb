module Myarik::Redash
  class Client
    include Myarik::Logger::Helper
    extend Forwardable

    def_delegators :conn, :get, :post, :delete

    attr_reader :url, :api_key

    def initialize(url:, api_key:)
      @url = url
      @api_key = api_key
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
        f.response :mashify
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    def data_source
      Api::DataSource.new(client: self)
    end


  end
end
