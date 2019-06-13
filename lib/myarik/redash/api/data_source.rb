module Myarik::Redash::Api
  class DataSource < Base

    CODENIZE_KEYS = %w(id name type options)

    def create(name:, type:, options:)
      client.post do |req|
        req.url '/api/data_sources'
        req.body = {
          name: name,
          type: type,
          options: options,
        }
      end
    end

    def update(name:, type:, options:)
      id = id_by_name!(name: name)
      client.post do |req|
        req.url "/api/data_sources/#{id}"
        req.body = {
          name: name,
          type: type,
          options: options,
        }
      end
    end

    def list
      client.get {|req|
        req.url '/api/data_sources'
      }
      .body
      .map(&:id)
      .map {|id|
        client.get {|req|
          req.url "/api/data_sources/#{id}"
        }
        .body
        .select {|k, _| CODENIZE_KEYS.include?(k)}
        .yield_self { |h| Hashie::Mash.new(h) }
      }
    end

    def delete(name:)
      id = id_by_name!(name: name)
      client.delete do |req|
        req.url "/api/data_sources/#{id}"
      end
    end

    private def id_by_name(name:)
      list.select {|ds| ds.name == name}.first.id
    end

    private def id_by_name!(name:)
      id_by_name(name: name).tap do |id|
        unless id
          raise Myarik::Error::RedashApiResourceNotFoundError, "data_source: #{name} does not found."
        end
      end
    end
  end
end
