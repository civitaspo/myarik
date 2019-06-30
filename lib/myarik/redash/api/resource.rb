module Myarik::Redash::Api
  class Resource

    AVAILABLE_REST_METHODS = Set.new(%i(get get_with_paging post delete))
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
        case m
        when :get_with_paging then _get_with_paging(data)
        else
          res = client.send(m) do |req|
            req.url complete_path(data.mash)
            req.body = data if REQUEST_BODY_REQUIRED_REST_METHODS.include?(m)
          end
          raise Myarik::Error::RedashApiError, res.body.to_json unless res.success?
          res.body
        end
      end
    end

    private def complete_path(data)
      return path unless path.include?(":id")
      path.gsub(%r{:id}, data.id.to_s)
    end

    private def _get_with_paging(data)
      [].tap do |results|
        paginator = lambda do |page = 1|
          res = client.get do |req|
            req.url complete_path(data.mash)
            req.params['page'] = page
          end
          raise Myarik::Error::RedashApiError, res.body.to_json unless res.success?

          results.push(*res['results'])

          if results.size < res["count"]
            paginator.call(page + 1)
          end
        end
        paginator.call
      end
    end

  end
end