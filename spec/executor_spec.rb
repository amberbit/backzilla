require 'spec/spec_helper'

class ExecutorTester
  include Backzilla::Executor
  
  attr_reader :debug_output
  attr_reader :error_output
  attr_reader :fatal_output

  def initialize
    @debug_output = []
    @error_output = []
    @fatal_output = []
  end

  def debug(msg)
    @debug_output << msg
  end

  def error(msg)
    @error_output << msg
  end

  def fatal(msg)
    @fatal_output << msg
  end
end

describe Backzilla::Executor do
 
  before(:each) do
    @executor = ExecutorTester.new
  end
  
  describe "success" do
    it "should not print anything" do
      @executor.execute "echo -n"
      @executor.debug_output.should eql(["echo -n"])
    end

    it "should print message from standard output" do
      cmd = "echo -n foo"
      @executor.execute cmd 
      @executor.debug_output.should eql([cmd, "foo"])
    end

    it "should print message from STDERR" do
      cmd = "echo -n foo 1>&2"
      @executor.execute cmd
      @executor.error_output.should eql(["foo"])
    end
  end

  describe "failure" do
    it "should exit with status 1" do
      cmd = "cp"
      lambda do
        @executor.execute cmd
      end.should raise_error SystemExit
      @executor.fatal_output.should_not be_empty
    end  
  end
end

