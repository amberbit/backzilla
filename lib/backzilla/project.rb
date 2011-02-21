class Backzilla::Project
  include Backzilla::LoggerHelper

  attr_reader :name
  attr_reader :entities

  def initialize(name)
    @name = name
    @entities = []
  end

  def <<(entity)
    entity.project = self
    @entities << entity
  end

  def setup_entities(entities_data)
    entities_data.each do |entity_name, entity_data|
      klass = Backzilla::Entity.const_get(entity_data['type'])
      self << klass.new(entity_name, entity_data)
    end
  end 
end

