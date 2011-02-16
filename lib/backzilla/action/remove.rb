class Backzilla::Action::Remove < Backzilla::Action
   
    def initialize(project)
    super(project)
  end
  
  def run(entity_name="")
    info "Project #{@project.name}:"
    if entity_name.blank?
      @project.entities.each do |name, entity|
        remove_entity(entity)
      end
    else
      remove_entity(@project.entities[entity_name])
    end
  end

  private 
    
    def remove_entity(entity)
      info "Removing #{@project.name}[:#{entity.name}]..."

      restores_file = File.expand_path STORES_CONFIG
      data = YAML.load_file restores_file
      stores = data['stores'].map do |store_name, store_options|
        klass = Backzilla::Store.const_get(store_options['type'])
        klass.new(store_name, @project.name, entity.name, store_options)
      end

      stores.each do |store|
        target = store.store_uri
        FileUtils.rm_rf target[7..-1] # POPRAWIC TO!!!
      end
    end
end
