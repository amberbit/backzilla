require 'spec/spec_helper'

PROJECTS_CONFIG_MYSQL = 'spec/configs/mysql/projects.yaml'
STORES_CONFIG_MYSQL = 'spec/configs/mysql/stores.yaml'

def create_mysql_database
    cmd =<<-CMD
      echo "create database backzilla_test;
            create table backzilla_test.users
              (user_id INT NOT NULL AUTO_INCREMENT,
               email VARCHAR(80) NOT NULL,
               name VARCHAR(50) NOT NULL,
               password CHAR(41) NOT NULL,
               PRIMARY KEY (user_id),
               UNIQUE INDEX (email));
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('1', 'Lukas@amberbit.com', 'Lukas Kowalski', 'qweasd');
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('2', 'Martin@amberbit.com', 'Martin Kowalski', 'qwezxc');
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('3', 'Wojtek@amberbit.com', 'Wojtek Kowalski', 'qwerty');
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('4', 'Paul@amberbit.com', 'Paul Kowalski', 'qweasd');
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('5', 'Hubert@amberbit.com', 'Hubert Kowalski', 'qweqwe');
             insert into backzilla_test.users
              (user_id, email, name, password)
              values
                ('6', 'Lukas2@amberbit.com', 'Lukas2 Kowalski', 'qweqwe');"  | \
      mysql -u #{$user} -p#{$password}
    CMD
    system(cmd)
  end

  def modify_mysql_database
    cmd =<<-CMD
      echo "update backzilla_test.users set
              name = 'Kacper the friendly ghoust'
              where user_id = 1" | \
      mysql -u #{$user} -p#{$password}
    CMD
    system(cmd)
  end

  def drop_mysql_database
    cmd =<<-CMD
      echo "drop database backzilla_test; " |\
      mysql -u #{$user} -p#{$password}
    CMD
    `#{cmd}`
  end

describe "Backzilla", "mysql", "backup preparation" do
  before :each do
    projects_file = File.expand_path PROJECTS_CONFIG_MYSQL
    data = YAML.load_file projects_file
    projects = data.inject([]) do |projects, project_data|
      project_name, project_entities_data = *project_data
      data[project_name].each do |entity_name, entity_data|
        $password = entity_data['password']
        $user = entity_data['user']
        @mysql = Backzilla::Entity::MySQL.new('test', entity_data)
      end
    end
    create_mysql_database
    @mysql.project = Backzilla::Project.new('test')
  end

  it "should prepare mysql database to be backed up" do
    # Before running this test you should create mysql dump manually and move resultant file "backzilla_test.sql" to
    # #{APP_ROOT}/spec/fixtures/mysql/
    path = Pathname.new(@mysql.prepare_backup)
    path.should == Pathname.new("/tmp/backzilla/test/test/backzilla_test.sql")
    flaga = false
    file1 = File.new(path, "r")
    file2 = File.new('spec/fixtures/mysql/backzilla_test.sql', "r")
    while (line1 = file1.gets)
      line2 = file2.gets
      unless line1.include? "-- Dump completed"
        unless line1.include? "-- Server version"
          line1.should == line2
        end
      end
    end
    file1.close
    file2.close
  end
end

describe "Backzilla", "mysql", "finalize restore" do
  before :each do
    projects_file = File.expand_path PROJECTS_CONFIG_MYSQL
    data = YAML.load_file projects_file
      projects = data.inject([]) do |projects, project_data|
        project_name, project_entities_data = *project_data
        data[project_name].each do |entity_name, entity_data|
          @mysql = Backzilla::Entity::MySQL.new('test', entity_data)
        end
      end
    @mysql.project = Backzilla::Project.new('test')
  end

  after(:all) do
    drop_mysql_database
  end

  it "should restore mysql database from given file" do
    modify_mysql_database
    @mysql.finalize_restore(:path => '/tmp/backzilla/test/test/')
    cmd =<<-CMD
      echo "select * from backzilla_test.users; " |\
      mysql -u #{$user} -p#{$password}
    CMD
   tmp = `#{cmd}`
   tmp.should_not include "Kacper the friendly ghoust"
  end
end

