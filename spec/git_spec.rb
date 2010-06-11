require File.dirname(__FILE__) + '/spec_helper.rb'

include Guitr::GuitrGit

describe Guitr::GuitrGit do
  
  describe GitStatus do
    
    before do
      @right_repo = File.expand_path(File.dirname(__FILE__)+'/../')
      @test_file_name = 'some_file'
      @action = GitStatus.new
    end
    
    it "should have a git instance if right repo was passed" do
      @action.run @right_repo, {}
      @action.git.should_not be_nil
    end
    
    it "should show untracked files" do
      begin
        file = open(@test_file_name, "w")
        res = @action.run @right_repo, {}
        res.should include @test_file_name
      ensure
        clean_test_file(file)
      end
    end
    
    it "should mark untracked files with U letter" do
      begin
        file = open(@test_file_name, "w")
        res = @action.run @right_repo, {}
        res.should_not include '??'
        res.should include 'U'
      ensure
        clean_test_file(file)
      end
    end
    
    def clean_test_file file
      file.close
      File.delete @test_file_name
    end
    private :clean_test_file
    
  end
  
  describe GitUnpushed do
    
    before do
      @right_repo = File.expand_path(File.dirname(__FILE__)+'/../')
      @action = GitUnpushed.new
      @test_file_name = 'some_file_2'
    end
    
    it "should have a git instance if repo path is correct" do
      @action.run @right_repo, {}
      @action.git.should_not be_nil
    end
    
    it "should display unpushed items or display nothing" do
      res = @action.run @right_repo, {}
      res.should be_empty if res.empty?
      res.should include('insertions') if !res.empty?
    end
    
  end
  
end