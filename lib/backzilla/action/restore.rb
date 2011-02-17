class Backzilla::Action::Restore < Backzilla::Action

  def initialize(entities, stores)
    super(entities, stores)
  end
  
  def run
    @entities.each do |name, entity|
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
    entity.finalize_restore if entity.respond_to?(:finalize_restore)
  end
end
