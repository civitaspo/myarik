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
      @all_dss ||= api_client.data_sources.get
                     .map(&:mash)
                     .map(&:id)
                     .sort
                     .map(&method(:data_source))

      return @all_dss if condition.empty?

      @all_dss.select do |ds|
        condition.mash.reduce(true) do |bool, (k, v)|
          bool and ds[k] == v
        end
      end
    end

    override def delete(data)
      api_client.data_source.delete(data)
    end

    private def data_source(id)
      props = api_client.data_source.get(id: id)
      props.select { |k, _| CODENIZE_KEYS.include?(k) }
    end
  end
end