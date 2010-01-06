class Backzilla::Entity::MySQL < Backzilla::Entity
  include Backzilla::Executor

  def initialize(name, options)
    super(name)
    @database = options['database']
    @mysql_options = {
      'user' => options['user'],
      'password' => options['password'],
    }
  end

  def backup
    if @database.blank?
      fatal "Database name is blank"
      exit -1
    end
    backup_msg
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path
    filename = path + "#{@database}.sql"

    cmd = "mysqldump #{mysql_options} #{@database} > #{filename}"
    execute cmd

    Backzilla.store path, project.name, self.name

    FileUtils.rm_rf path
  end

  def restore
    restore_msg
    raise 'Not implemented'
  end

  private

  def mysql_options
    @mysql_options.inject([]) do |options, mysql_option|
      name, value = *mysql_option
      unless value.blank?
        options << "--#{name}=#{value}"
      end
      options
    end.join(' ')
  end
end

