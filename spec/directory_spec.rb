require 'spec/spec_helper'

describe "Backzilla", "directory" do
  before :each do
    setup_directory
    prefix_configs "directory"
  end

  it "should back up directories to local filesystem" do
    run_backzilla("-b")
    File.exist? "spec/backups/directory_backup"    
  end

  it "should back up directories to FTP"

  it "should back up directories to SSH"

  it "should restore directories from local filesystem"

  it "should restore directories from FTP"

  it "should restore directories from SSH" 
end

