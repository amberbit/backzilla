require 'fileutils'
$LOAD_PATH.unshift "lib"
require 'backzilla'

Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  #
  # == Notes
  #
  # For more information take a look at Spec::Example::Configuration and Spec::Runner

  def prefix_configs(prefix)
    @prefix = prefix
  end

  def run_backzilla(options)
    option = options[:option]
    cmd = "./bin/backzilla #{option} #{options[:project_name]}"
    if @prefix
      cmd = "BACKZILLA_STORES_CONFIG=spec/configs/#{@prefix}/stores.yaml " + cmd
      cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/#{@prefix}/projects.yaml " + cmd
    end
    `sh -c "#{cmd}"`
  end

  def directory_path
    if !File.exist? "/tmp/backzilla/#{@prefix}"
      if !File.exist? "/tmp/backzilla"
        FileUtils.mkdir "/tmp/backzilla"
      end
      FileUtils.mkdir "/tmp/backzilla/#{@prefix}"
    end
    "/tmp/backzilla/#{@prefix}"
  end
   
  def setup_directory
    FileUtils.cp_r "spec/fixtures/directory", "/tmp/backzilla/"
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

  def modify_mongodb_database
     cmd =<<-CMD
       echo "use backzilla_test
             db.users.update({name: \\"Paweł\\"},{\\$set:{name: \\"Wiesław\\"}})
             db.users.find()" |\
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
              name = 'Kacper the friendly ghost'
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
end

