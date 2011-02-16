class Backzilla::Entity::MongoDB < Backzilla::Entity
  include Backzilla::Executor

  def initialize(name, options)
    super(name)
    @database = options['database']
  end

  def prepare_backup
    if @database.blank?
      fatal "Database name is blank"
      exit -1
    end
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path
    cmd = "mongodump -d #{@database} -o #{path}"
    execute cmd 
    backup_msg
    path
  end

  # FileUtils.rm_rf path

  def finalize_restore(options={})
    path = options[:path]
    cmd = "mongorestore --drop -d #{@database} #{path}/#{@database}"
    execute cmd

    FileUtils.rm_rf path
  end

  def restore
    restore_msg
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path

    Backzilla.restore path, project.name, self.name
    finalize_restore(:path => path)
  end

  def remove
    Backzilla.remove @path, project.name, self.name
    @path
  end
end

