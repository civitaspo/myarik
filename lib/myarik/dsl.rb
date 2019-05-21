class Myarik::DSL
  class << self
    def convert(exported)
      Dslh.deval(exported, root_identify: true)
    end

    def parse(dsl, path, options = {})
      Myarik::DSL::Context.eval(dsl, path, options)
    end
  end # of class methods
end
