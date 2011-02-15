require 'net/ssh'

class Backzilla::Store::SSH < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
    @host = options['host']
    @user = options['user']
  end

  def put(source_path, project_name, entity_name)
    Net::SSH.start(@host, @user ) do |ssh|
      ssh.exec "mkdir -p " + @path.to_s + "/#{project_name}/#{entity_name}"
    end
    
    target = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"
    duplicity = Duplicity.new(@@gnugpg_passphrase, source_path, target)
    duplicity.store
  end

  def get(source_path, project_name, entity_name)
    source = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"       
    duplicity = Duplicity.new(@@gnugpg_passphrase, source, source_path)
    duplicity.restore
  end

  private
  
  def protocol
    'ssh'
  end

  def uri
    if @path.blank?
      fatal "Missing path option"
      exit -1
    end

    uri = ''
    uri << "#{@user}@" unless @user.blank?
    uri << @host
    uri << "/"
    uri << @path
  end
end

