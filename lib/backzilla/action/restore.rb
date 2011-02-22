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
    store = @stores.first
    info "Restoring from #{store.name} ..."
    source = store.store_uri(entity.project.name, entity.name)
    duplicity = Backzilla::Duplicity.new(source, path)
    duplicity.restore
    entity.finalize_restore
  end
end
