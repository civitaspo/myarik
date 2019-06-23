class Myarik::Exporter
  include Myarik::Utils::TargetMatcher
  include Myarik::Utils::DupMarker

  def initialize(model, options = {})
    @model = model
    @options = options
  end

  def export
    @model.all.map(&:mash).reduce({}) do |results, resource|
      results.tap do |r|
        k = resource.name.dup
        k = with_dup_mark(k) if r.has_key?(k)
        r[k] = resource
      end
    end
  end

end
