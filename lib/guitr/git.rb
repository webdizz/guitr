require 'git'

module Guitr
  module GuitrGit
    
    class GitStatus
      
      attr_reader :git
      
      def run(repo, options = {})
        @git = Git.open(repo, options)
        res = @git.lib.status
        puts 
        puts "Status for #{repo}"
        puts res = res.gsub('??', ' U')
        puts
        
        res
      end
      
    end
    
    class GitUnpushed
      
      attr_reader :git
      
      def run(repo, options={})
        puts 'Unpushed:'
        @git = Git.open(repo, options)
        git_lib = @git.lib
        current_branch = git_lib.branch_current
        res = git_lib.unpushed(current_branch, "#{git_lib.remotes}/#{current_branch}")
        puts res
        res
      end
      
    end
    
  end
end

module Git
  
  class Lib
    
    def status
      command('status', ['--porcelain'])
    end
    
    def unpushed branch, remote_branch
      command('diff', ['--numstat', '--shortstat', branch, remote_branch])
    end
    
  end
end
