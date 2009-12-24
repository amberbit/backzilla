module Backzilla::LoggerHelper
  [:fatal, :error, :warn, :info, :debug].each do |method_name|
    severity = Logger.const_get(method_name.to_s.upcase)
    define_method(method_name) do |msg|
      msg = msg.pretty_inspect unless String === msg
      Backzilla.logger.log severity, msg
    end
  end
end

