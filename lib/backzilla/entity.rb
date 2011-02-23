class Backzilla::Entity
  autoload :Directory, 'backzilla/entity/directory'
  autoload :MongoDB, 'backzilla/entity/mongo_db'
  autoload :MySQL, 'backzilla/entity/my_sql'
  autoload :CapistranoRails, 'backzilla/entity/capistrano_rails'

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

  def backup_msg(options={})
      info "Entity name: [#{name}]. Type of backing up files: [#{self.class.demodulize}]"
  end

  def restore_msg(options={})
      info "Entity name: [#{name}]. Type of restoring files: [#{self.class.demodulize}]"
  end
end

