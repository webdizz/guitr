require File.dirname(__FILE__) + '/spec_helper.rb'
require 'logger'

describe Guitr::GuitrRunner do
  
  $CURRENT_DIR_PATH = File.expand_path(File.dirname(__FILE__))
  $RIGHT_REPO_PATH = File.expand_path(File.dirname(__FILE__)+'/../')
  
  before(:each) do
    @guitr_runner = Guitr::GuitrRunner.new
  end
  
  it "should continue if no args were specified" do
    args = [];
    @guitr_runner.validate args
    @guitr_runner.operation.should  eql(:status)
  end
  
  it "should use current directory if no path specified" do
    args = [];
    @guitr_runner.validate args
    @guitr_runner.repo_paths.size.should eql(1)
  end
  
  it "should fail if specified directory does not exist" do
    args = ['some_path'];
    lambda { @guitr_runner.validate(args)}.should raise_exception SystemExit
  end
  
  it "should use specified directory if exist" do
    args = [$RIGHT_REPO_PATH];
    lambda { @guitr_runner.validate(args)}.should_not raise_exception SystemExit
  end
  
  it "should fail if there is are no repositories within specified directory" do
    args = [$CURRENT_DIR_PATH];
    lambda { @guitr_runner.validate(args)}.should raise_exception SystemExit
  end
  
  it "should operate verbosely if --verbose was specified" do
    args = ['--verbose', $RIGHT_REPO_PATH]
    @guitr_runner.validate args
    @guitr_runner.log.should_not be_nil
  end
  
  it "should use INFO logger if --verbose was specified" do
    args = ['--verbose', $RIGHT_REPO_PATH]
    @guitr_runner.validate args
    @guitr_runner.log.level.should eql(Logger::INFO)
  end
  
  it "should operate in debug mode if --trace was specified" do
    args = ['--trace', $RIGHT_REPO_PATH]
    @guitr_runner.validate args
    @guitr_runner.log.level.should eql(Logger::DEBUG)
  end
  
  it "should use first operation argument to operate with" do
    args = ['--trace', '--status', '--pull', $RIGHT_REPO_PATH]
    @guitr_runner.validate args
    @guitr_runner.operation.should eql(:status.to_s)
  end
  
  it "should have unpushed operation" do
    args = ['--unpushed'];
    @guitr_runner.validate args
    @guitr_runner.operation.should  eql(:unpushed.to_s)
  end
  
  it "should have empty or some satistic of unpushed changes" do
    args = ['--unpushed', $RIGHT_REPO_PATH];
    res = @guitr_runner.run args
    res.should be_empty if res.empty?
    res.should include('insertions') if !res.empty?
    res.should_not include('nothing to do')
  end
  
end
