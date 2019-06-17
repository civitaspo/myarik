module Myarik::Redash
  class Model

    class Factory

      attr_reader :api_client

      def initialize(api_client:)
        @api_client = api_client
      end

      def create(name)
        model_class = "Myarik::Redash::#{name.to_s.classify}".constantize
        model_class.new(api_client: api_client)
      end
    end

    class << self

      def factory(api_client:)
        Factory.new(api_client: api_client)
      end

    end

    extend Abstriker
    extend Overrider

    attr_reader :api_client

    def initialize(api_client:)
      @api_client = api_client
    end

    abstract def create(data)
    end
    abstract def update(data)
    end
    abstract def all
    end
    abstract def find_by(name)
    end
    abstract def delete(data)
    end
  end
end