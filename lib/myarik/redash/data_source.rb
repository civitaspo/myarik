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

    override def where(condition = {})
      @all_data_sources ||= api_client.data_sources.get
                              .map { |ds| ds['id'] }
                              .sort
                              .map(&method(:find_data_source))

      return @all_data_sources if condition.empty?

      @all_data_sources.select do |ds|
        condition.reduce(true) do |bool, (k, v)|
          bool and ds[k.to_s] == v
        end
      end
    end

    override def delete(data)
      api_client.data_source.delete(data)
    end

    private def find_data_source(id)
      props = api_client.data_source.get(id: id)
      props.select { |k, _| CODENIZE_KEYS.include?(k) }
    end
  end
end