class Backzilla::Store
  autoload :Directory, 'backzilla/store/directory'
  autoload :FTP, 'backzilla/store/ftp'

  include Backzilla::LoggerHelper
  include Backzilla::Executor

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.gnugpg_passphrase=(value)
    @@gnugpg_passphrase = value
  end

  def put(source_path, project_name, entity_name)
    cmd =<<-CMD
      PASSPHRASE='#{@@gnugpg_passphrase}' #{env_options} \\
      duplicity #{source_path} #{protocol}://#{uri}/#{project_name}/#{entity_name}
    CMD
    execute cmd
  end

  def get(destination_path)
    cmd =<<-CMD
      PASSPHRASE='#{@@gnugpg_passphrase}' #{env_options} \\
      duplicity #{protocol}://#{uri} #{destination_path}
    CMD
    excute cmd
  end

  private

  def env_options
    env_options = environment_options.inject('') do |m, option|
      name, value = *option
      next if value.blank?
      m << "#{name.to_s.upcase}='#{value}' "
    end
  end

  def environment_options
    {}
  end
end

