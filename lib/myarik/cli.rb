class Myarik::CLI < Thor
  include Myarik::Logger::Helper

  class_option :target, type: :string, required: false
  class_option :redash_url, type: :string, reqired: false
  class_option :redash_api_key, type: :string, required: false
  class_option :color, type: :boolean, default: true
  class_option :debug, type: :boolean, default: false

  desc 'apply FILE', 'apply'
  option :'dry-run', type: :boolean, default: false
  def apply(file)
    cli = client(options)

    log(:info, "Apply `#{file}`")
    updated = cli.apply(file)

    unless updated
      log(:info, 'No change'.intense_blue)
    end
  end

  desc 'export [FILE]', 'export'
  def export(file = nil)
    cli = client(options)
    dsl = cli.export

    if file.nil? or file == '-'
      puts dsl
    else
      log(:info, "Export to `#{file}`")
      open(file, 'wb') {|f| f.puts dsl }
    end
  end

  desc 'version', 'show version'
  def version
    puts Myarik::VERSION
  end

  private

  def client(options)
    options = options.dup
    underscoreize!(options)
    fill_required_options!(options: options)

    String.colorize = options[:color]
    Myarik::Logger.instance.set_debug(options[:debug])

    disable_static_analyzers unless options[:debug]

    cli = Myarik::Client.new(options)
  end

  def underscoreize!(options)
    options.keys.each do |key|
      if key.to_s =~ /-/
        if value = options.delete(key)
          key = key.to_s.gsub('-', '_').to_sym
          options[key] = value
        end
      end
    end
  end

  def fill_required_options!(options:)
    %i(redash_url redash_api_key).each do |o|
      options[o] ||= ENV["MYARIK_#{o.to_s.upcase}"] || raise(Myarik::Error::ConfigError, "'#{o}' must be set.")
    end
  end

  def disable_static_analyzers
    log(:info, 'Disable static analyzers that means "override", "abstract" modifiers')
    Overrider.disable = true
    Abstriker.disable = true
    Finalist.disable = true
  end
end
