class Backzilla::Entity::Directory < Backzilla::Entity
  def initialize(name, options)
    super(name)
  end

  def backup
    backup_msg
    raise 'Not implemented'
  end

  def restore
    restore_msg
    raise 'Not implemented'
  end
end

