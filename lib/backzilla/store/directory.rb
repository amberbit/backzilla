class Backzilla::Store::Directory < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
  end  
    
  def store_uri(project_name, entity_name)
    "#{protocol}://#{uri}/#{project_name}/#{entity_name}"
  end

  def prepare_store(project_name, entity_name)
  end

  def remove_uri(project_name, entity_name)
    "#{uri}/#{project_name}/#{entity_name}"
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

