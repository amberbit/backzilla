class Backzilla::Action::Backup < Backzilla::Action
  
  def initialize(entities, stores)
    super(entities, stores)
  end
  
  def run
    @entities.each do |name, entity|
      store_entity(entity)
    end
  end

  private 
    
  def store_entity(entity)
    path = entity.prepare_backup 
    info "Storing #{path}..."    
    @stores.each do |store|
      info "Storing in #{store.name}..."

      target = store.store_uri(entity.project.name, entity.name)   
      duplicity =  Backzilla::Duplicity.new(path, target)
      duplicity.store
    end
    entity.clean if entity.respond_to?(:clean)
  end
end
