module Myarik::Redash
  class DataSource < Model

    # TODO: cannot get theas from DSL?
    CODENIZE_KEYS = Set.new(%w(id name type options))

    override def create(data)
      api_client.data_sources.post(data)
    end

    override def update(data)
      api_client.data_source.post(data)
    end

    override def all
      sorted_ds_ids = api_client.data_sources.get.map(&:id).sort
      sorted_ds_ids.map(&method(:data_source))
    end

    override def find_by(data)
      id = api_client.data_sources.get.select { |ds|
        data.reduce(true) { |bool, (k, v)|
          bool and ds[k] == v
        }
      }.first

      return nil unless id

      data_source(id)
    end

    override def delete(data)
      api_client.data_source.delete(data)
    end

    private def data_source(id)
      props = api_client.data_source.get('id' => id)
      props
        .select { |k, _| CODENIZE_KEYS.include?(k) }
        .yield_self { |h| Hashie::Mash.new(h) }
    end
  end
end