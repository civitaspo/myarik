class Myarik::Exporter
  include Myarik::Utils::TargetMatcher

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def export
    {}.tap do |results|
      results["data_source"] = {}.tap do |data_source|
        @client.list.each do |ds|
          data_source[ds.name] = {
            'name' => ds.name,
            'type' => ds.type,
            'options' => ds.options,
          }
        end
      end
    end
  end
end
