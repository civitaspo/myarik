class Myarik::Exporter
  include Myarik::Utils::TargetMatcher

  def initialize(client, options = {})
    @client = client
    @options = options
  end

  def export
    # FIXME:
    warn 'FIXME: Exporter#export() not implemented'.yellow

    # FIXME: this is an example
    {"server"=>
      {"web"=>
        {"middleware"=>"nginx",
         "tag"=>
          [{"key"=>"Name", "value"=>"web-001"}, {"key"=>"Role", "value"=>"Web"}]},
       "database"=>
        {"middleware"=>"mysql",
         "tag"=>
          [{"key"=>"Name", "value"=>"db-002"}, {"key"=>"Role", "value"=>"DB"}]}}}
  end
end
