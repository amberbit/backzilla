class Backzilla::Action
  autoload :Backup, 'backzilla/action/backup' 
  autoload :Restore, 'backzilla/action/restore'
  autoload :Remove, 'backzilla/action/remove'
  autoload :Store, 'backzilla/store'
  autoload :Duplicity, 'backzilla/duplicity'

  
  include Backzilla::LoggerHelper 
     
  STORES_CONFIG = ENV["BACKZILLA_STORES_CONFIG"] || "~/.backzilla/stores.yaml"
  PROJECTS_CONFIG = ENV["BACKZILLA_PROJECTS_CONFIG"] || "~/.backzilla/projects.yaml"

  def initialize(project)
    @project = project
  end
end 
