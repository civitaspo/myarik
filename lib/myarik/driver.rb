class Myarik::Driver
  include Myarik::Logger::Helper
  include Myarik::Utils::Diff
  include Myarik::Utils::DupMarker

  def initialize(model, options = {})
    @model = model
    @options = options
  end

  def create(name, attrs)
    name = without_dup_mark(name)
    log(:info, "Create '#{name}'", color: :cyan)

    unless @options[:dry_run]
      attrs.update('name' => name)
      @model.create(**symbolize(attrs))
    end
  end

  def delete(name, attrs)
    n = without_dup_mark(name)
    reason =
      if n != name
        "Duplicated resource"
      else
        "Unexpected resource"
      end
    log(:info, "Delete '#{n}' (Reason: #{reason}, attributes: #{attrs.to_json})", color: :red)

    unless @options[:dry_run]
      attrs.update('name' => n)
      @model.delete(**symbolize(attrs))
    end
  end

  def update(name, attrs, old_attrs)
    name = without_dup_mark(name)
    log(:info, "Update '#{name}'", color: :green)
    log(:info, diff(old_attrs, attrs, color: @options[:color]), color: false)

    unless @options[:dry_run]
      attrs.update('name' => name)
      @model.update(**symbolize(attrs))
    end
  end

  private def symbolize(attrs)
    attrs.map {|k, v| [k.to_sym, v] }.to_h
  end
end
