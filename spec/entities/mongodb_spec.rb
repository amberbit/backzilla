# -*- encoding: utf-8 -*-
require './spec/spec_helper'

PROJECTS_CONFIG_MONGO = 'spec/configs/mongodb/projects.yaml'

describe "Backzilla", "mongodb", "backup preparation" do
  before :each do
    projects_file = File.expand_path PROJECTS_CONFIG_MONGO
    data = YAML.load_file projects_file
      projects = data.inject([]) do |projects, project_data|
        project_name, project_entities_data = *project_data
        data[project_name].each do |entity_name, entity_data|
          @mongodb = Backzilla::Entity::MongoDB.new('test', entity_data)
        end
      end
      create_mongodb_database
    @mongodb.project = Backzilla::Project.new('test')
  end

  it "should prepare database to be backed up" do
    path = Pathname.new(@mongodb.prepare_backup)
    path.should == Pathname.new("/tmp/backzilla/test/test")

    cmd =<<-CMD
      cd /tmp/backzilla/test/test/backzilla_test/
      md5sum users.bson
    CMD
    $md5sum_before_backup = `#{cmd}`
  end
end

describe "Backzilla", "mongodb", "finalize restore" do
  before :each do
    projects_file = File.expand_path PROJECTS_CONFIG_MONGO
    data = YAML.load_file projects_file
      projects = data.inject([]) do |projects, project_data|
        project_name, project_entities_data = *project_data
        data[project_name].each do |entity_name, entity_data|
          @mongodb = Backzilla::Entity::MongoDB.new('test', entity_data)
        end
      end
    @mongodb.project = Backzilla::Project.new('test')
  end

  after(:all) do
    drop_mongodb_database
  end

  it "should restore database from given file" do
    modify_mongodb_database
    @mongodb.finalize_restore
    cmd =<<-CMD
      echo "use backzilla_test
           db.users.find()" |\
      mongo
    CMD
   tmp = `#{cmd}`
   tmp.should_not include "Wiesiek"
  end

  it "should restore the exact same database" do
    path = Pathname.new(@mongodb.prepare_backup)
    cmd =<<-CMD
      cd /tmp/backzilla/test/test/backzilla_test/
      md5sum users.bson
    CMD
    $md5sum_after_backup = `#{cmd}`

    $md5sum_before_backup.should == $md5sum_after_backup
  end
end

