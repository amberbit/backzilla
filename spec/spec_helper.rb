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
end

