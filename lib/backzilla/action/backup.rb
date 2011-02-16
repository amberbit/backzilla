class Backzilla::Action::Backup < Backzilla::Action
  
  def initialize(project)
    super(project)
  end
  
  def run(entity_name="")
    info "Project #{@project.name}:"
    if entity_name.blank?
      @project.entities.each do |name, entity|
        store_entity(entity)
      end
    else
      store_entity(@project.entities[entity_name])
    end
  end

  private 
    
    def store_entity(entity)
      path = entity.prepare_backup 
      info "Storing #{path}..."
      
      stores_file = File.expand_path STORES_CONFIG
      data = YAML.load_file stores_file
      stores = data['stores'].map do |store_name, store_options|
        klass = Backzilla::Store.const_get(store_options['type'])
        klass.new(store_name, @project.name, entity.name, store_options)
      end
      
      stores.each do |store|
        info "Storing in #{store.name}..."
        target = store.store_uri
        duplicity =  Duplicity.new(data['gnupg_passphrase'], path, target)
        duplicity.add_env_option(*store.environment_options)
        duplicity.store
      end
    end
end
