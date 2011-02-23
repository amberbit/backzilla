class Backzilla::Entity::CapistranoRails < Backzilla::Entity
  include Backzilla::Executor
  
  def initialize(name, options)
    super(name)
    @database_type = options['database_type']
    @path = Pathname.new(File.expand_path(options['path']))
    @shared_directory = @path + "shared"
    if @database_type == "MySQL"
      parse_yaml_file(@path + "current/config/database.yml") 
    else
      parse_yaml_file(@path + "current/config/mongoid.yml")
    end
  end

  def prepare_backup
    backup_msg
    validate_path
     
    if @database_type == "MySQL"
      filename = @shared_directory + "#{@database}.sql"
      cmd = "mysqldump --user=#{@user} --password=#{@password} #{@database} > #{filename}"
      execute cmd
    else
      cmd = "mongodump -d #{@database} -o #{@shared_directory}"
      execute cmd 
    end  
    @shared_directory
  end

  def prepare_restore
    restore_msg
    validate_path
    FileUtils.rm_rf @shared_directory
    FileUtils.mkdir @shared_directory
    @shared_directory
  end

  def finalize_restore
    if @database_type == "MySQL"
      sql_file_path = @shared_directory + "#{@database}.sql"
      Dir.glob(sql_file_path).each do |dir|
        cmd = "mysql --user=#{@user} --password=#{@password} #{@database} <"+dir
        execute cmd
      end
      FileUtils.rm_rf sql_file_path
    else
      mongo_files_path = @shared_directory + @database
      cmd = "mongorestore --drop -d #{@database} #{mongo_files_path}"
      execute cmd
      FileUtils.rm_rf mongo_files_path
    end
  end

  def clean
    if @database_type == "MySQL"
      filepath = @shared_directory + "#{@database}.sql"
      FileUtils.rm filepath
    else
      directorypath = @shared_directory + @database
      FileUtils.rm_rf directorypath
    end
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

  def parse_yaml_file(path)
    data = YAML.load_file path
    @user = data['production']['username']
    @password = data['production']['password']
    @database = data['production']['database']
  end
end
