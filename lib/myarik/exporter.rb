class Myarik::Exporter
  include Myarik::Utils::TargetMatcher
  include Myarik::Utils::DupMarker

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def export
    {}.tap do |results|
      Myarik::DSL::ROOT_KEYS.each do |target_resource|
        results[target_resource] = export_by_resource(target_resource)
      end
    end
  end

  private def export_by_resource(target_resource)
    @client.send(target_resource.to_sym).list.reduce({}) do |results, resource|
      results.tap do |r|
        if r[resource.name]
          r[with_dup_mark(resource.name)] = resource
        else
          r[resource.name] = resource
        end
      end
    end
  end

end
