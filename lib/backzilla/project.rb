class Backzilla::Project
  include Backzilla::LoggerHelper

  attr_reader :name

  def initialize(name)
    @name = name
    @entities = {}
  end

  def <<(entity)
    entity.project = self
    @entities[entity.name] = entity
  end

  def setup_entities(entities_data)
    entities_data.each do |entity_name, entity_data|
      klass = Backzilla::Entity.const_get(entity_data['type'])
      self << klass.new(entity_name, entity_data)
    end
  end

  def backup(spec_parts)
    info "Project #{name}:"
    if spec_parts.empty?
      @entities.each { |name, entity| entity.backup }
    else
      @entities[spec_parts.shift].backup
    end
  end

  def restore(spec_parts)
    info "Project #{name}:"
    if spec_parts.empty?
      @entities.each { |name, entity| entity.restore }
    else
      @entities[spec_parts.shift].restore
    end
  end
end

