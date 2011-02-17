class Backzilla::Duplicity
  include Backzilla::Executor
  include Backzilla::LoggerHelper
 
  def initialize(source, target)
    @source = source
    @target = target
    @options = ""
    @env_options = ""
  end
  
  def self.gnupg_passphrase=(value)
    @@gnupg_passphrase = value
  end

  def store
    cmd =<<-CMD
      PASSPHRASE='#{@@gnupg_passphrase}' #{@env_options} \\
      duplicity #{@options} #{@source} #{@target}
    CMD
    execute cmd
  end

  def restore
    cmd =<<-CMD
      PASSPHRASE='#{@@gnupg_passphrase}' #{@env_options} \\
      duplicity restore #{@options} #{@source} #{@target}
    CMD
    execute cmd
  end

  def add_env_option(key,value)
    unless key.blank? || value.blank?
      @env_options += "#{key.upcase}=#{value} "
    end
  end

  def add_option(option)
    if option[0,2] == "--"
      @options += "#{option} "
    else
      @options += "--#{option} "
    end
  end
end
