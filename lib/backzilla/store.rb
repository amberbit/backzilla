class Backzilla::Store
  autoload :Directory, 'backzilla/store/directory'
  autoload :FTP, 'backzilla/store/ftp'
  autoload :SSH, 'backzilla/store/ssh'
  autoload :Duplicity, 'backzilla/duplicity'

  include Backzilla::LoggerHelper
  include Backzilla::Executor

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def self.gnugpg_passphrase=(value)
    @@gnugpg_passphrase = value
  end
 
  def delete(source_path, project_name, entity_name)
    FileUtils.rm_rf "#{uri}/#{project_name}/#{entity_name}"
  end
end

