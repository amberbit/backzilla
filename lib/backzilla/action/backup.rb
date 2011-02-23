class Backzilla::Action::Backup
  include Backzilla::Action
    
  def run
    @entities.each do |entity|
      store_entity(entity)
    end
  end

  private 
    
  def store_entity(entity)
    path = entity.prepare_backup 
    info "Storing #{path}..."    
    @stores.each do |store|
      info "Storing in #{store.name}..."
      store.prepare_store
      target = store.store_uri(entity.project.name, entity.name)   
      duplicity =  Backzilla::Duplicity.new(path, target)
      duplicity.store
    end
    entity.clean
  end
end
