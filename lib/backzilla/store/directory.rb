class Backzilla::Store::Directory < Backzilla::Store
  def initialize(name, options)
    super(name)
    @path = options['path']
  end
  
  def put(source_path, project_name, entity_name)
    target = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"
    duplicate =  Duplicity.new(@@gnugpg_passphrase, source_path, target)
    duplicate.store
  end

  def get(source_path, project_name, entity_name)
    source = "#{protocol}://#{uri}/#{project_name}/#{entity_name}"       
    duplicity = Duplicity.new(@@gnugpg_passphrase, source, source_path)
    duplicity.restore
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

