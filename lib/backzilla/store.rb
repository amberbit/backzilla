class Backzilla::Store
  autoload :Directory, 'backzilla/store/directory'
  autoload :FTP, 'backzilla/store/ftp'
  autoload :SSH, 'backzilla/store/ssh'
  
  include Backzilla::LoggerHelper
  include Backzilla::Executor

  attr_reader :name

  def initialize(name)
    @name = name
  end
end

