class Backzilla::Action::Restore
  include Backzilla::Action
  
  def run
    @entities.each do |entity|
      restore_entity(entity)
    end
  end

  private 
    
  def restore_entity(entity)
    path = entity.prepare_restore
    info "Restoring #{path}..."
    @stores.each do |store|
      source = store.store_uri(entity.project.name, entity.name)
      duplicity = Backzilla::Duplicity.new(source, path)
      duplicity.restore
    end
    entity.finalize_restore
  end
end
