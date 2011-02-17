# NcFTP required
class Backzilla::Store::FTP < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
    @host = options['host']
    @user = options['user']
    @password = options['password']
  end
 
  def store_uri
    "#{protocol}://#{uri}/#{@project_name}/#{@entity_name}" 
  end
  
  def environment_options
    ["FTP_PASSWORD", @password]
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
    uri << "#{@user}:#{@password}@" unless @user.blank?
    uri << @host
    uri << @path
  end

end

