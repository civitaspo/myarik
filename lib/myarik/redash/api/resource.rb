module Myarik::Redash::Api
  class Resource

    AVAILABLE_REST_METHODS = Set.new(%i(get post delete))
    REQUEST_BODY_REQUIRED_REST_METHODS = Set.new(%i(post))

    attr_reader :client, :path, :rest_methods

    def initialize(client:, path:, rest_methods: [])
      @client = client
      @path = path
      @rest_methods = rest_methods

      @rest_methods.each(&method(:define_rest_method))
    end

    private def define_rest_method(m)
      raise ConfigError, "Unsupported m: #{m}" unless AVAILABLE_REST_METHODS.include?(m)

      define_singleton_method(m) do |data = {}|
        res = client.send(m) do |req|
          req.url complete_path(data)
          req.body = data if REQUEST_BODY_REQUIRED_REST_METHODS.include?(m)
        end
        hashify(res.body)
      end
    end

    private def complete_path(data)
      return path unless path.include?(":id")
      path.gsub(%r{:id}, data['id'].to_s)
    end

    private def hashify(data)
      data = {} if data.nil?
      if data.is_a?(Array)
        data.map do |h|
          Hashie::Mash.new(h)
        end
      else
        Hashie::Mash.new(data)
      end
    end

  end
end