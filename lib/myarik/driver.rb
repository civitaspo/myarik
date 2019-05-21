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
      # FIXME:
      warn 'FIXME: Driver#create() not implemented'.yellow
    end
  end

  def delete(name, attrs)
    log(:info, "Delete '#{name}'", color: :red)

    unless @options[:dry_run]
      # FIXME:
      warn 'FIXME: Driver#delete() not implemented'.yellow
    end
  end

  def update(name, attrs, old_attrs)
    log(:info, "Update '#{name}'", color: :green)
    log(:info, diff(old_attrs, attrs, color: @options[:color]), color: false)

    unless @options[:dry_run]
      # FIXME:
      warn 'FIXME: Driver#update() not implemented'.yellow
    end
  end
end
