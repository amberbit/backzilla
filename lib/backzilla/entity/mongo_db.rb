class Backzilla::Entity::MongoDB < Backzilla::Entity
  include Backzilla::Executor

  def initialize(name, options, base_path = '/tmp/backzilla')
    super(name, base_path)
    @database = options['database']
  end

  def prepare_backup
    if @database.blank?
      fatal "Database name is blank"
      exit -1
    end
    path = Pathname.new(@base_path) + project.name + name
    FileUtils.mkdir_p path
    cmd = "mongodump -d #{@database} -o #{path}"
    execute cmd 
    backup_msg
    path
  end

  def prepare_restore
    restore_msg
    path = Pathname.new(@base_path) + project.name + name 
    FileUtils.mkdir_p path unless File.exist?(path)
    path
  end

  def finalize_restore
    path = Pathname.new(@base_path) + project.name + name
    path = path + @database
    cmd = "mongorestore --drop -d #{@database} #{path}"
    execute cmd
    FileUtils.rm_rf path
  end
  
  def clean
    path = Pathname.new(@base_path) + project.name + name + @database
    FileUtils.rm_rf path
  end
end

