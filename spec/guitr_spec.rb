require File.dirname(__FILE__) + '/spec_helper.rb'
require 'logger'
require 'optparse'

describe Guitr::GuitrRunner do
  
  $CURRENT_DIR_PATH = File.expand_path(File.dirname(__FILE__))
  $RIGHT_REPO_PATH = File.expand_path(File.dirname(__FILE__)+'/../')
  
  before(:each) do
    ARGV.clear
    @guitr_runner = Guitr::GuitrRunner.new
  end
  
  it "should continue if no args were specified" do
    @guitr_runner.run
    @guitr_runner.operation.should  eql(:status)
  end
  
  it "should use current directory if no path specified" do
    @guitr_runner.run
    @guitr_runner.repo_paths.size.should eql(1)
  end
  
  it "should fail if specified directory does not exist" do
    ARGV << 'some_path'
    lambda { @guitr_runner.run}.should raise_exception SystemExit
  end
  
  it "should use specified directory if exist" do
    ARGV << $RIGHT_REPO_PATH
    lambda { @guitr_runner.run}.should_not raise_exception SystemExit
  end
  
  it "should fail if there is are no repositories within specified directory" do
    ARGV << $CURRENT_DIR_PATH
    lambda { @guitr_runner.run}.should raise_exception SystemExit
  end
  
  it "should operate verbosely if --verbose was specified" do
    ARGV << '--verbose'
    ARGV << $RIGHT_REPO_PATH
    @guitr_runner.run
    @guitr_runner.log.should_not be_nil
  end
  
  it "should use INFO logger if --verbose was specified" do
    ARGV << '--verbose'
    ARGV << $RIGHT_REPO_PATH
    @guitr_runner.run
    @guitr_runner.log.level.should eql(Logger::INFO)
  end
  
  it "should operate in debug mode if --trace was specified" do
    ARGV << '--trace'
    ARGV << $RIGHT_REPO_PATH
    @guitr_runner.run
    @guitr_runner.log.level.should eql(Logger::DEBUG)
  end
  
  it "should use first operation argument to operate with" do
    ARGV << '--trace'
    ARGV << '--status'
    ARGV << '--pull'
    ARGV << $RIGHT_REPO_PATH
    @guitr_runner.run
    @guitr_runner.operation.should eql(:status)
  end
  
  it "should have unpushed operation" do
    ARGV << '--unpushed'
    @guitr_runner.run
    @guitr_runner.operation.should  eql(:unpushed)
  end
  
  it 'should run specified command' do
    ARGV << '--exec'
    ARGV << 'date'
    @guitr_runner.run
    @guitr_runner.operation.should  eql(:exec)
  end
  
  it 'should fail to run specified command' do
    lambda { 
      ARGV << '--exec'
      @guitr_runner.run
    }.should raise_exception OptionParser::ParseError
  end
    
end
