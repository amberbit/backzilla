require './spec/spec_helper'

describe "Backzilla", "Capistrano Rails" do
  
  describe "MySQL database" do
    
    before(:all) do 
      $user = "root"
      $password = "sword4fish"  
      entity_data = {'path' => 'spec/fixtures/capistrano_rails_project/app', 'database_type' => 'MySQL'}
      @capistrano_rails = Backzilla::Entity::CapistranoRails.new('capistrano_rails_mysql', entity_data)
      @capistrano_rails.project = Backzilla::Project.new('test')
    end
    
    after(:all) do
      sql_file_path = Pathname.new("spec/fixtures/capistrano_rails_project/app/shared/backzilla_test.sql")
      FileUtils.rm(sql_file_path) if File.exists?(sql_file_path)
      dropm_mysql_database
    end

    describe "prepare backup" do
      it "should prepare MySQL database dump file and put it in the 'shared' directory" do
        sql_file_path = Pathname.new("spec/fixtures/capistrano_rails_project/app/shared/backzilla_test.sql")
        FileUtils.rm(sql_file_path) if File.exists?(sql_file_path)
        path = Pathname.new(@capistrano_rails.prepare_backup) 
        path.should == sql_file_path
        File.exists?(path).should be_true
      end
    end
    
    describe "prepare restore" do
      it "should build valid path to MySQL database dump file in the 'shared' directory" do
        path = Pathname.new(@capistrano_rails.prepare_restore)
        path.should == Pathname.new("spec/fixtures/capistrano_rails_project/app/shared/backzilla_test.sql")
      end
    end

    describe "finalize restore" do
      it "should restore MySQL database from given file" do
        modify_mysql_database
        @capistrano_rails.finalize_restore
        cmd =<<-CMD
          echo "select * from backzilla_test.users; " |\
          mysql -u #{$user} -p#{$password}
        CMD
        tmp = `#{cmd}`
        tmp.should_not include "Kacper the friendly ghost"
        tmp.should include "Lukas Kowalski"
      end
    end
  end
  
  describe "MongoDB database" do
    
    before(:all) do
      create_mongodb_database
      entity_data = {'path' => 'spec/fixtures/capistrano_rails_project/app', 'database_type' => 'MongoDB'}
      @capistrano_rails = Backzilla::Entity::CapistranoRails.new('capistrano_rails_mongo', entity_data)
      @capistrano_rails.project = Backzilla::Project.new('test')
    end

    after(:all) do
      drop_mongodb_database
      mongo_file_path = Pathname.new("spec/fixtures/capistraon_rails_project/app/shared/backzilla_test")
      FileUtils.rm_rf(mongo_file_path) if File.exists?(mongo_file_path)
    end

    describe "prepare backup" do
      it "should prepare MongoDB database dump file and put it in the 'shared' directory" do
        mongo_file_path = Pathname.new("spec/fixtures/capistraon_rails_project/app/shared/backzilla_test")
        FileUtils.rm_rf(mongo_file_path) if File.exists?(mongo_file_path)
        path = Pathname.new(@capistrano_rails.prepare_backup) 
        path.should == mongo_file_path
        File.exists?(path+"users.bson").should be_true
      end
    end
    
    describe "prepare restore" do
      it "should build valid path to MongoDB database dump file in the 'shared' directory" do
        path = Pathname.new(@capistrano_rails.prepare_restore)
        path.should == Pathname.new("spec/fixtures/capistrano_rails_project/app/shared/backzilla_test")
      end
    end
    
    describe "finalize restore" do
      it "should restore MongoDB database from given file" do
        modify_mongodb_database
        @capistrano_rails.finalize_restore
        cmd =<<-CMD
          echo "use backzilla_test
           db.users.find()" |\
          mongo
        CMD
        tmp = `#{cmd}`
        tmp.should_not include "Wiesiek"
      end
    end
  end 
end

