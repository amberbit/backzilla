class Backzilla::Action::Remove < Backzilla::Action
   
  def initialize(entities, stores)
    super(entities, stores)
  end
  
  def run
    @entities.each do |name, entity|
      remove_entity(entity)
    end
  end

  private 
    
  def remove_entity(entity)
    # info "Removing #{@project.name}[:#{entity.name}]..."

    @stores.each do |store|
      target = store.store_uri(entity.project.name, entity.name)
      FileUtils.rm_rf target[7..-1] # POPRAWIC TO!!!
    end
  end
end
