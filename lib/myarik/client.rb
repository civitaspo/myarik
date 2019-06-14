class Myarik::Client
  include Myarik::Utils::TargetMatcher

  def initialize(options = {})
    @options = options
    @client = @options[:client] || Myarik::Redash::Client.new(url: options[:redash_url], api_key: options[:redash_api_key])
    @exporter = Myarik::Exporter.new(@client, @options)
  end

  def export
    expected = @exporter.export
    Myarik::DSL.convert(expected)
  end

  def apply(file)
    expected = load_file(file)
    actual =  @exporter.export

    updated = walk(expected, actual)

    if @options[:dry_run]
      false
    else
      updated
    end
  end

  private

  def walk(expected, actual)
    updated = false

    Myarik::DSL::ROOT_KEYS.each do |target_resource|
      # FIXME: handle more resources.
      expected = expected.fetch(target_resource)
      actual = actual.fetch(target_resource)

      driver = new_driver(target_resource)

      expected.each do |name, expected_attrs|
        next unless target?(name)

        actual_attrs = actual.delete(name)

        if actual_attrs
          # TODO: exclude id ?

          if expected_attrs != actual_attrs
            driver.update(name, expected_attrs, actual_attrs)
            updated = true
          end
        else
          driver.create(name, expected_attrs)
          updated = true
        end
      end

      actual.each do |name, actual_attrs|
        next unless target?(name)
        driver.delete(name, actual_attrs)
        updated = true
      end
    end

    updated
  end

  def load_file(file)
    if file.kind_of?(String)
      open(file) do |f|
        Myarik::DSL.parse(f.read, file, @options)
      end
    elsif file.respond_to?(:read)
      Myarik::DSL.parse(file.read, file.path, @options)
    else
      raise TypeError, "can't convert #{file} into File"
    end
  end

  def new_driver(target_resource)
    Myarik::Driver.new(@client.send(target_resource.to_sym), @options)
  end
end
