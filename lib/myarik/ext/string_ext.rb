module Myarik::Ext
  module StringExt
    module ClassMethods
      def colorize=(value)
        @colorize = value
      end

      def colorize
        @colorize
      end
    end # ClassMethods

    Term::ANSIColor::Attribute.named_attributes.each do |attribute|
      class_eval(<<-EOS, __FILE__, __LINE__ + 1)
        def #{attribute.name}
          if String.colorize
            Term::ANSIColor.send(#{attribute.name.inspect}, self)
          else
            self
          end
        end
      EOS
    end

    # like active support
    def classify
      self.split('_').collect!(&:capitalize).join
    end

    # like active support
    def constantize
      names = self.split("::".freeze)

      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(self) if names.empty?

      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?

      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)

          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject(constant) do |const, ancestor|
            break const if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end

          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

  end
end

String.send(:include, Myarik::Ext::StringExt)
String.extend(Myarik::Ext::StringExt::ClassMethods)
