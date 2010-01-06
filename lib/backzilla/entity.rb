class Backzilla::Entity
  autoload :Directory, 'backzilla/entity/directory'
  autoload :MongoDB, 'backzilla/entity/mongo_db'
  autoload :MySQL, 'backzilla/entity/my_sql'

  include Backzilla::LoggerHelper

  BASE_PATH = '/tmp/backzilla'

  attr_reader :name
  attr_accessor :project

  def initialize(name)
    @name = name
  end

  private

  def self.demodulize
    to_s.split('::').last
  end

  def backup_msg
    info "[#{self.class.demodulize}] Backing up #{name}..."
  end

  def restore_msg
    info "[#{self.class.demodulize}] Restoring #{name}..."
  end
end

