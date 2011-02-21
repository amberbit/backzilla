require 'yaml'
require 'pp'
require 'ostruct'
require 'logger'
require 'fileutils'
require 'pathname'

require 'rubygems'
require 'open4'

class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

module Backzilla
  autoload :LoggerHelper, 'backzilla/logger_helper'
  autoload :Project, 'backzilla/project'
  autoload :Entity, 'backzilla/entity'
  autoload :Store, 'backzilla/store'
  autoload :Executor, 'backzilla/executor'
  autoload :Version, 'backzilla/version'
  autoload :Configuration, 'backzilla/configuration'
  autoload :Action, 'backzilla/action'
  autoload :Duplicity, 'backzilla/duplicity'

  include Backzilla::Version
  include Backzilla::Executor
  extend Backzilla::LoggerHelper

  STORES_CONFIG = ENV["BACKZILLA_STORES_CONFIG"] || "~/.backzilla/stores.yaml"
  PROJECTS_CONFIG = ENV["BACKZILLA_PROJECTS_CONFIG"] || "~/.backzilla/projects.yaml" 
  
  def self.logger
    return @logger if @logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @logger.progname = 'Backzilla'
    @logger
  end

  def self.options
    Backzilla::Configuration.instance
  end

  def self.run(options)
    config = Backzilla::Configuration.instance
    options.each do |key, value|
      config.send "#{key}=", value
    end

    if config.backup && config.restore && config.remove
      fatal "Use --remove, -r or -b separately"
      exit -1
    elsif !config.backup && !config.restore && !config.remove
      fatal "--remove, -r or -b required"
      exit -1
    end
    
    # Parsing stores.yaml file
    stores_file = File.expand_path STORES_CONFIG
    data = YAML.load_file stores_file
    Backzilla::Duplicity.gnupg_passphrase = data["gnupg_passphrase"]
    stores = data['stores'].map do |store_name, store_options|
      klass = Backzilla::Store.const_get(store_options['type'])
      klass.new(store_name, store_options)
    end
    
    # Parsing project.yaml file
    projects_file = File.expand_path PROJECTS_CONFIG
    data = YAML.load_file projects_file

    if config.spec == 'all'
      projects = data.inject([]) do |projects, project_data|
        project_name, project_entities_data = *project_data
        project = Project.new(project_name)
        project.setup_entities data[project_name]
        projects << project
      end
      klass = Backzilla::Action.const_get(config.action)
      projects.each { |project| klass.new(project.entities, stores).run }
    else
      spec_parts = config.spec.split(':')
      project_name = spec_parts.shift
      
      entity = {}
      unless spec_parts.empty? 
        name = spec_parts.shift
        entity[name] = data[project_name][name]
      end

      unless data[project_name]
        fatal "No such project '#{project_name}'"
        exit 1
      end
      project = Project.new(project_name)
      project.setup_entities(entity.empty? ? data[project_name] : entity)
      
      klass = Backzilla::Action.const_get(config.action)
      klass.new(project.entities, stores).run
    end
  end
end

