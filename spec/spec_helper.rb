require 'fileutils'

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

  config.before(:all) do
    FileUtils.rm_rf "tmp"
    FileUtils.mkdir_p "tmp"
  end

  def prefix_configs(prefix)
    @prefix = prefix
  end

  def run_backzilla(options)
    cmd = "./bin/backzilla #{options}"
    if @prefix
      cmd = "BACKZILLA_STORES_CONFIG=spec/configs/#{@prefix}/stores.yaml " + cmd
      cmd = "BACKZILLA_PROJECTS_CONFIG=spec/configs/#{@prefix}/projects.yaml " + cmd
    end
  end

  def setup_directory
    FileUtils.mkdir_p "tmp/directory/some/nested/stuff"
    [ "tmp/directory/a.txt", "tmp/directory/b.txt", 
      "tmp/directory/some/nested/stuff/c.txt" ].each do |filename|
      FileUtils.touch filename
    end
  end
end
 
