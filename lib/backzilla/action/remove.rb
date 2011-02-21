class Backzilla::Action::Remove
  include Backzilla::Action
     
  def run
    @entities.each do |entity|
      remove_entity(entity)
    end
  end

  private 
    
  def remove_entity(entity)
    info "Removing #{entity.project.name}[:#{entity.name}]..."

    @stores.each do |store|
      target = store.remove_uri(entity.project.name, entity.name)
      
      FileUtils.rm_rf target
    end
  end
end
