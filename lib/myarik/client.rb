class Myarik::Client
  include Myarik::Utils::TargetMatcher

  def initialize(options = {})
    @options = options
    @client = @options[:client] || Myarik::Redash::Api::Client.new(
      url: options[:redash_url],
      api_key: options[:redash_api_key]
    )
    @mf = Myarik::Redash::Model.factory(api_client: @client)
  end

  def export
    Myarik::DSL.convert(export_actual)
  end

  private def export_actual
    Myarik::DSL::ROOT_KEYS.reduce({}) do |results, key|
      results.tap do |r|
        exporter = new_exporter(key)
        r[key] = exporter.export
      end
    end
  end

  private def new_exporter(target_resource)
    Myarik::Exporter.new(@mf.create(target_resource), @options)
  end

  private def new_driver(target_resource)
    Myarik::Driver.new(@mf.create(target_resource), @options)
  end

  def apply(file)
    expected = load_file(file)
    actual =  export_actual

    updated = walk(expected, actual)

    if @options[:dry_run]
      false
    else
      updated
    end
  end

  private def walk(expected, actual)
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
          actual_attrs_without_id = actual_attrs.dup
          actual_attrs_without_id.delete(:id)

          if expected_attrs != actual_attrs_without_id
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

  private def load_file(file)
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
end
