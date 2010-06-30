#mongodump -d tree_test -o /tmp
class Backzilla::Entity::MongoDB < Backzilla::Entity
  include Backzilla::Executor

  def initialize(name, options)
    super(name)
    @database = options['database']
  end

  def backup
    if @database.blank?
      fatal "Database name is blank"
      exit -1
    end
    backup_msg
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path

    cmd = "mongodump -d #{@database} -o #{path}"
    execute cmd

    Backzilla.store path, project.name, self.name

    FileUtils.rm_rf path
  end

  def restore
    restore_msg
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path

    Backzilla.restore path, project.name, self.name

    cmd = "mongorestore --drop -d #{@database} #{path}/#{@database}"
    execute cmd

    FileUtils.rm_rf path
  end
end

