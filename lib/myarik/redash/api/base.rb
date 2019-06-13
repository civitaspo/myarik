module Myarik::Redash::Api
  class Base

    extend Abstriker
    extend Overrider

    attr_reader :client

    def initialize(client:)
      @client = client
    end

    abstract def path
    end

    abstract def create(data)
    end

    abstract def update(data)
    end

    abstract def list
    end

    abstract def delete(data)
    end

  end
end
