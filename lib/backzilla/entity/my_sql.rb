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

  def prepare_backup
    if @database.blank?
      fatal "Database name is blank"
      exit -1
    end
    path = Pathname.new(BASE_PATH) + project.name + name
    FileUtils.mkdir_p path
    filename = path + "#{@database}.sql"
    cmd = "mysqldump #{mysql_options} #{@database} > #{filename}"
    execute cmd
    backup_msg
    filename
  end
  
  def prepare_restore
    restore_msg
    path = Pathname.new(BASE_PATH) + project.name + name 
    FileUtils.mkdir_p path unless File.exist?(path)
    path + "#{@database}.sql"
  end

  def finalize_restore 
    path = Pathname.new(BASE_PATH) + project.name + name
    path = path + "#{@database}.sql"
    Dir.glob(path).each do |dir|
      cmd = "mysql #{mysql_options} #{@database} <"+dir
      execute cmd
    end
    FileUtils.rm_rf path
  end 

  def clean
    path = Pathname.new(BASE_PATH)
    FileUtils.rm_rf path
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

