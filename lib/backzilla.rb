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

  include Backzilla::Version
  extend Backzilla::LoggerHelper

  def self.store(path)
    info "Storing #{path}..."

    stores_file = File.expand_path(File.dirname(__FILE__)) + '/../stores.yaml'
    data = YAML.load_file stores_file
    Store.gnugpg_passphrase = data['gnupg_passphrase']
    stores = data['stores'].map do |store_name, store_options|
      klass = Backzilla::Store.const_get(store_options['type'])
      klass.new(store_name, store_options)
    end

    stores.each { |s| s.put path }
  end

  def self.logger
    return @logger if @logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::DEBUG
    @logger.progname = 'Backzilla'
    @logger
  end

  def self.run(options)
    if options.backup && options.restore
      fatal "Use -r or -b separately"
      exit -1
    elsif !options.backup && !options.restore
      fatal "-r or -b required"
      exit -1
    end

    projects_file = File.expand_path(File.dirname(__FILE__)) + '/../projects.yaml'
    data = YAML.load_file projects_file
    if options.spec == 'all'
      raise 'Not implemented'
    else
      spec_parts = options.spec.split(':')
      project_name = spec_parts.shift
      unless data[project_name]
        fatal "No such project '#{project_name}'"
        exit -1
      end

      project = Project.new(project_name)
      data[project_name].each do |entity_name, entity_data|
        klass = Backzilla::Entity.const_get(entity_data['type'])
        project << klass.new(entity_name, entity_data)
      end

      if options.backup
        project.backup spec_parts
      elsif options.restore
        project.restore spec_parts
      end
    end
  end
end

