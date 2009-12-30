class Backzilla::Entity::Directory < Backzilla::Entity
  def initialize(name, options)
    super(name)
    @path = options['path']
  end

  def backup
    backup_msg
    if @path.blank?
      fatal 'path option missing'
      exit -1
    end

    Backzilla.store @path, project.name, self.name

    @path
  end

  def restore
    restore_msg
    raise 'Not implemented'
  end
end

