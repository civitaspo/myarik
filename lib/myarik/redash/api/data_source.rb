module Myarik::Redash::Api
  class DataSource < Base

    CODENIZE_KEYS = %w(id name type options)

    override def path
      '/api/data_sources'
    end

    override def create(data)
      client.post do |req|
        req.url path
        req.body = data
      end
    end

    override def update(data)
      id = id_by_name!(name: data[:name])
      client.post do |req|
        req.url "#{path}/#{id}"
        req.body = data
      end
    end

    override def list
      client.get {|req|
        req.url path
      }
      .body
      .map(&:id)
        .sort
      .map {|id|
        client.get {|req|
          req.url "#{path}/#{id}"
        }
        .body
        .select {|k, _| CODENIZE_KEYS.include?(k)}
        .yield_self { |h| Hashie::Mash.new(h) }
      }
    end

    override def delete(data)
      id = id_by_name!(name: data[:name])
      client.delete do |req|
        req.url "#{path}/#{id}"
      end
    end

    private def id_by_name(name:)
      list.select {|ds| ds.name == name}.sort_by(&:id).first.id
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
