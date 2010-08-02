require 'spec/spec_helper'

PROJECTS_CONFIG = 'spec/configs/remove_files/projects.yaml'
STORES_CONFIG = 'spec/configs/remove_files/stores.yaml'

  def clean_up
    FileUtils.rm_rf "/tmp/backzilla/"
    drop_mongodb_database
  end

  def create_mongodb_database
  cmd =<<-CMD
    echo "use backzilla_test
          db.users.insert({name: 'Paweł', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})
          db.users.insert({name: 'Łukasz1', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})
          db.users.insert({name: 'Łukasz2', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})
          db.users.insert({name: 'Wojtek', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})
          db.users.insert({name: 'Marcin', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})
          db.users.insert({name: 'Hubert', email: 'cokolwiek@amberbit.com', password: 'qweqwe'})" |\
    mongo
  CMD
  `#{cmd}`
  end

  def drop_mongodb_database
    cmd =<<-CMD
      echo "use backzilla_test
            db.dropDatabase()" |\
      mongo
    CMD
    `#{cmd}`
  end

describe "Backzilla", "Remove" do
  before :each do
    setup_directory
    create_mongodb_database
  end

  after(:all) do
    clean_up
  end

  it "should remove given project from all stores" do
    cmd = "./bin/backzilla -b test1"
    cmd = "BACKZILLA_STORES_CONFIG=spec/configs/remove_files/stores.yaml " + cmd
    cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/remove_files/projects.yaml " + cmd
    `sh -c "#{cmd}"`

    cmd = "./bin/backzilla --remove test1"
    cmd = "BACKZILLA_STORES_CONFIG=spec/configs/remove_files/stores.yaml " + cmd
    cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/remove_files/projects.yaml " + cmd
    `sh -c "#{cmd}"`

    cmd = "ls spec/backups/remove_files_spec1/test1/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
    cmd = "ls spec/backups/remove_files_spec2/test1/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
  end

  it "should remove all projects from all stores" do
    cmd = "./bin/backzilla -b all"
    cmd = "BACKZILLA_STORES_CONFIG=spec/configs/remove_files/stores.yaml " + cmd
    cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/remove_files/projects.yaml " + cmd
    `sh -c "#{cmd}"`

    cmd = "./bin/backzilla --remove all"
    cmd = "BACKZILLA_STORES_CONFIG=spec/configs/remove_files/stores.yaml " + cmd
    cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/remove_files/projects.yaml " + cmd
    `sh -c "#{cmd}"`

    cmd = "ls spec/backups/remove_files_spec1/test1/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
    cmd = "ls spec/backups/remove_files_spec2/test1/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
    cmd = "ls spec/backups/remove_files_spec1/test2/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
    cmd = "ls spec/backups/remove_files_spec2/test2/|wc -l"
    files = `#{cmd}`
    files.to_i.should == 0
  end

end

