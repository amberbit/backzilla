class Backzilla::Action::Restore < Backzilla::Action

  def initialize(project)
    super(project)
  end
  
  def run(entity_name="")
    info "Project #{@project.name}:"
    if entity_name.blank?
      @project.entities.each do |name, entity|
        restore_entity(entity)
      end
    else
      restore_entity(@project.entities[entity_name])
    end
  end

  private 
    
    def restore_entity(entity)
      path = entity.finalize_restore
      info "Restoring #{path}..."
      restores_file = File.expand_path STORES_CONFIG
      data = YAML.load_file restores_file
      stores = data['stores'].map do |store_name, store_options|
        klass = Backzilla::Store.const_get(store_options['type'])
        klass.new(store_name, @project.name, entity.name, store_options)
      end
      stores.each do |store|
        source = store.store_uri
        duplicity = Duplicity.new(data['gnupg_passphrase'], source, path)
        duplicity.restore
      end
    end
end
