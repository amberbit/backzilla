require 'net/sftp'

class Backzilla::Store::SSH < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
    @host = options['host']
    @user = options['user']

  end

  def store_uri(project_name, entity_name)
    path = Pathname.new(@path) + project_name + entity_name
    Net::SFTP.start(@host, @user) do |sftp|
      dir = Pathname.new("")
      path.each_filename do |filename|
        dir += filename
        sftp.mkdir! dir
      end
    end 
    "#{protocol}://#{uri}/#{project_name}/#{entity_name}" 
  end
 
  def remove_uri(project_name, entity_name)
    ""
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

