require 'spec/spec_helper'

def remove_files
  FileUtils.rm_rf "/tmp/backzilla/"
  FileUtils.rm_rf "spec/backups/"
  FileUtils.rm "spec/fixtures/file.md5"
end

describe "Backzilla", "Directory" do
  before :each do
    prefix_configs "directory"
    directory_path
    setup_directory
  end

  after(:all) do
    remove_files
  end

  it "should prepare files to be backuped up" do
    if !File.exist? "spec/fixtures/file.md5"
      FileUtils.touch "spec/fixtures/file.md5"
    else
      FileUtils.rm "spec/fixtures/file.md5"
      FileUtils.touch "spec/fixtures/file.md5"
    end
    cmd =<<-CMD
      find #{directory_path} -type f -print0 | xargs -0 md5sum >> spec/fixtures/file.md5
    CMD
    `#{cmd}`
    run_backzilla(:option => "-b", :project_name => "test")
  end

  it "should restore files" do
    run_backzilla(:option => "-r", :project_name => "test")
    cmd =<<-CMD
      cp spec/fixtures/file.md5 /tmp/backzilla
      cd #{directory_path}
      sh -c "LANG=en md5sum -c /tmp/backzilla/file.md5 | grep -v OK"
    CMD
    $md5sum_result = `#{cmd}`
    $md5sum_result.should == ""
  end

end

