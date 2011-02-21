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
  
  def prepare_restore
    restore_msg
    validate_path
    FileUtils.rm_rf @path
    FileUtils.mkdir @path
    @path
  end

  def finalize_restore; end
  def clean; end
  
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

