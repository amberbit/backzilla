class Backzilla::Store
  autoload :Directory, 'backzilla/store/directory'
  autoload :FTP, 'backzilla/store/ftp'
  autoload :SSH, 'backzilla/store/ssh'
  autoload :Duplicity, 'backzilla/duplicity'

  include Backzilla::LoggerHelper
  include Backzilla::Executor

  attr_reader :name

  def initialize(name, project_name, entity_name)
    @name = name
    @project_name = project_name
    @entity_name = entity_name
  end

  def environment_options
    ["",""]
  end
end

