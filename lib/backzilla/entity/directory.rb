class Backzilla::Entity::Directory < Backzilla::Entity
  def initialize(name, options)
    super(name)
    @path = options['path']
  end

  def prepare_backup
    backup_msg
    validate_path
    @path
  end

  def backup
    prepare_backup
    Backzilla.store @path, project.name, self.name
    @path
  end

  def finalize_restore
    restore_msg
    validate_path
    @path
  end

  def restore
    finalize_restore
    FileUtils.rm_rf @path
    FileUtils.mkdir @path
    Backzilla.restore @path, project.name, self.name
    @path
  end

  def remove
    Backzilla.remove @path, project.name, self.name
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

