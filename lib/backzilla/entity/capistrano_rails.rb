class Backzilla::Entity::CapistranoRails < Backzilla::Entity
  include Backzilla::Executor
  
  def initialize(name, options)
    super(name, '/tmp/backzilla') 
    @path = Pathname.new(File.expand_path(options['path']))
    @shared_directory = @path + "shared"

    database_type = options['database_type']
    if database_type == "MySQL"
      data = parse_yaml_file(@path + "current/config/database.yml")  
    else
      data = parse_yaml_file(@path + "current/config/mongoid.yml")
    end
    klass = Backzilla::Entity.const_get(database_type)
    @entity = klass.new("shared", data, '/')
    @entity.project = Backzilla::Project.new(@path) 
  end

  def prepare_backup
    backup_msg
    validate_path
    @entity.prepare_backup
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
    @entity.finalize_restore
  end

  def clean
    @entity.clean
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
    {
      'user' => data['production']['username'],
      'password' => data['production']['password'],
      'database' => data['production']['database']
    }
  end
end
