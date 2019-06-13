class Myarik::Exporter
  include Myarik::Utils::TargetMatcher
  include Myarik::Utils::DupMarker

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def export
    {}.tap do |results|
      results["data_source"] = export_data_sources
    end
  end

  private def export_data_sources
    @client.list.inject({}) do |results, ds|
      results.tap do |r|
        data = {
          'name' => ds.name,
          'type' => ds.type,
          'options' => ds.options,
        }
        if r[ds.name]
          # NOTE: To remove duplicated named resource
          r[with_dup_mark(ds.name)] = data
        else
          r[ds.name] = data
        end
      end
    end
  end
end
