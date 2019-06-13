class Myarik::Exporter
  include Myarik::Utils::TargetMatcher
  include Myarik::Utils::DupMarker

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def export
    {}.tap do |results|
      results["data_source"] = {}.tap do |data_source|
        @client.list.each do |ds|
          data = {
            'name' => ds.name,
            'type' => ds.type,
            'options' => ds.options,
          }
          if data_source[ds.name]
            # NOTE: To remove duplicated named resource
            data_source[with_dup_mark(ds.name)] = data
            next
          end
          data_source[ds.name] = data
        end
      end
    end
  end
end
