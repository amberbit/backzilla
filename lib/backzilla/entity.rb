class Backzilla::Entity
  autoload :MySQL, 'backzilla/entity/my_sql'
  autoload :Directory, 'backzilla/entity/directory'

  include Backzilla::LoggerHelper

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

