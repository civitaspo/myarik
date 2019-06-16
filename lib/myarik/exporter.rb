class Myarik::Exporter
  include Myarik::Utils::TargetMatcher
  include Myarik::Utils::DupMarker

  def initialize(model, options = {})
    @model = model
    @options = options
  end

  def export
    @model.all.reduce({}) do |results, resource|
      results.tap do |r|
        k = resource.name
        k = with_dup_mark(resource.name) if r.has_key?(k)
        r[k] = resource
      end
    end
  end

end
