# NcFTP required
class Backzilla::Store::FTP < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
    @host = options['host']
    @user = options['user']
    @password = options['password']
  end

  def put(source_path, project_name, entity_name)
    target = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"
    duplicate =  Duplicate.new(@@gnugpg_passphrase, source_path, target)
    duplicate.add_env_option("FTP_PASSWORD", @password)
    duplicate.store
  end

  def get(source_path, project_name, entity_name)
    source = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"       
    duplicity = Duplicity.new(@@gnugpg_passphrase, source, source_path)
    duplicity.add_env_option("FTP_PASSWORD", @password)
    duplicity.restore
  end

  private

  def protocol
    'ftp'
  end

  def uri
    if @path.blank?
      fatal "Missing path option"
      exit -1
    end
    if @host.blank?
      fatal "Missing host option"
      exit -1
    end

    uri = ''
    uri << "#{@user}@" unless @user.blank?
    uri << @host
    uri << @path
  end

  def environment_options
    {:FTP_PASSWORD => @password}
  end
end

