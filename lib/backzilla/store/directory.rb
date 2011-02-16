class Backzilla::Store::Directory < Backzilla::Store
  def initialize(name, project_name, entity_name, options)
    super(name, project_name, entity_name)
    @path = options['path']
  end  
    
  def store_uri
    "#{protocol}://#{uri}/#{@project_name}/#{@entity_name}"
  end

  private

  def protocol
    'file'
  end

  def uri
    if @path.blank?
      fatal "Missing path option"
      exit -1
    end
    @path
  end
end

