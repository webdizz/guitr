require File.dirname(__FILE__) + '/spec_helper.rb'
require 'timeout'

include Guitr::GuitrGit

describe Guitr::GuitrGit do
  
  $RIGHT_REPO = File.expand_path(File.dirname(__FILE__)+'/../tmp')
  
  before(:all) do
    FileUtils.rm_rf $RIGHT_REPO
    Dir.mkdir $RIGHT_REPO
    Git::init($RIGHT_REPO)
  end
  
  after(:all) do
    FileUtils.rm_rf $RIGHT_REPO
  end
  
  describe GitStatus do
    
    before do
      @test_file_name = $RIGHT_REPO+'/some_file'
      @action = GitStatus.new
    end
    
    it "should have a git instance if right repo was passed" do
      @action.run $RIGHT_REPO, {}
      @action.git.should_not be_nil
    end
    
    it "should show untracked files" do
      begin
        file = open(@test_file_name, "w")
        res = @action.run $RIGHT_REPO, {}
        res.should include File.basename @test_file_name
      ensure
        clean_test_file(file)
      end
    end
    
    it "should mark untracked files with U letter" do
      begin
        file = open(@test_file_name, "w")
        res = @action.run $RIGHT_REPO, {}
        res.should_not include '??'
        res.should include 'U'
      ensure
        clean_test_file(file)
      end
    end
    
  end
  
  describe GitUnpushed do
    
    before do
      @action = GitUnpushed.new
      @test_file_name = $RIGHT_REPO+'/some_file_2'
    end
    
    it "should have a git instance if repo path is correct" do
      @action.run $RIGHT_REPO, {}
      @action.git.should_not be_nil
    end
    
    it "should display unpushed items" do
      module Git
        class Lib
          def branch_current
            'master'
          end
          def remotes
            'master'
          end
          def unpushed current_branch, remote_branch
            'insertions some additional statistics'
          end
        end
      end
      
      res = @action.run $RIGHT_REPO, {}
      res.should include('insertions')
    end
    
    it "should report an error without interruption if error was occured on unpushed action" do
      lambda{
        module Git
          class Lib
            def unpushed branch, remote_branch
              raise Git::GitExecuteError.new("Something was wrong")
            end
          end
        end
        @action.run $RIGHT_REPO, {}
      }.should_not raise_exception Git::GitExecuteError
    end
    
  end
  
  describe GitPull do
    
    before do
      @action = GitPull.new
      @test_file_name = $RIGHT_REPO+'/some_file_2'
    end
    
    it "should have a git instance if repo path is correct" do
      @action.run $RIGHT_REPO, {}
      @action.git.should_not be_nil
    end
    
    it "should display unpushed items or display nothing" do
      res = @action.run $RIGHT_REPO, {}
      res.should include('Updating')
    end
    
    it "should report an error without interruption if error was occured on pull action" do
      lambda{
        module Git
          class Lib
            def pull
              raise Git::GitExecuteError.new("Something was wrong")
            end
          end
        end
        @action.run $RIGHT_REPO, {}
      }.should_not raise_exception Git::GitExecuteError
    end
    
  end
  
  def clean_test_file file
    file.close
    File.delete @test_file_name
  end
  private :clean_test_file
  
end

module Git
  
  class Lib
    
    def pull
      'Updating'
    end
    
  end
end