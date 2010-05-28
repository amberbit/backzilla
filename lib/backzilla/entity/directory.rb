class Backzilla::Entity::Directory < Backzilla::Entity
  def initialize(name, options)
    super(name)
    @path = options['path']
  end

  def backup
    backup_msg
    validate_path

    Backzilla.store @path, project.name, self.name

    @path
  end

  def restore
    restore_msg
    validate_path

    Backzilla.restore @path, project.name, self.name

    @path
  end

  private

  def validate_path
    if @path.blank?
      fatal 'path option missing'
      exit -1
    end
    unless File.exist?(@path)
      fatal "path doesn't exist"
      exit -1
    end
  end
end

