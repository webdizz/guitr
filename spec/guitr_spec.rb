require File.dirname(__FILE__) + '/spec_helper.rb'

describe Guitr::GuitrRunner do
  
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
    args = [File.expand_path(File.dirname(__FILE__)+'/../')];
    lambda { @guitr_runner.validate(args)}.should_not raise_exception SystemExit
  end
  
  it "should fail if there is are no repositories within specified directory" do
    args = [File.expand_path(File.dirname(__FILE__))];
    lambda { @guitr_runner.validate(args)}.should raise_exception SystemExit
  end
  
end
