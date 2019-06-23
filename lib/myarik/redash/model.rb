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
    extend Finalist

    attr_reader :api_client

    def initialize(api_client:)
      @api_client = api_client
    end

    final def model(name)
      @factory ||= Model.factory(api_client: api_client)
      @factory.create(name)
    end

    abstract def create(data)
    end

    abstract def update(data)
    end

    abstract def delete(data)
    end

    abstract def where(condition = {})
    end

    def all
      where
    end

    def find_by(condition = {})
      where(condition).first
    end

  end
end