module Myarik::Error
  class Error < ::StandardError; end
  class ConfigError < Error; end
  class RedashApiError < Error; end
end
