class Myarik::Driver
  include Myarik::Logger::Helper
  include Myarik::Utils::Diff

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def create(name, attrs)
    log(:info, "Create '#{name}'", color: :cyan)

    unless @options[:dry_run]
      attrs.update('name' => name)
      @client.create(**symbolize(attrs))
    end
  end

  def delete(name, attrs)
    log(:info, "Delete '#{name}'", color: :red)

    unless @options[:dry_run]
      @client.delete(name: name)
    end
  end

  def update(name, attrs, old_attrs)
    log(:info, "Update '#{name}'", color: :green)
    log(:info, diff(old_attrs, attrs, color: @options[:color]), color: false)

    unless @options[:dry_run]
      attrs.update('name' => name)
      @client.update(**symbolize(attrs))
    end
  end

  private def symbolize(attrs)
    attrs.map {|k, v| [k.to_sym, v] }.to_h
  end
end
