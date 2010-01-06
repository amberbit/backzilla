module Backzilla::LoggerHelper
  [:fatal, :error].each do |method_name|
    severity = Logger.const_get(method_name.to_s.upcase)
    define_method(method_name) do |msg|
      log severity, msg
    end
  end

  [:warn, :info].each do |method_name|
    severity = Logger.const_get(method_name.to_s.upcase)
    define_method(method_name) do |msg|
      unless Backzilla.options.quiet
        log Logger::WARN, msg
      end
    end
  end

  def debug(msg)
    if !Backzilla.options.quiet && Backzilla.options.debug
      log Logger::DEBUG, msg
    end
  end

  private

  def log(severity, msg)
    msg = msg.pretty_inspect unless String === msg
    Backzilla.logger.log severity, msg
  end
end

