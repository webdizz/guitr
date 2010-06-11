require 'git'
require 'logger'

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
        @git = Git.open(repo, options)
        git_lib = @git.lib
        current_branch = git_lib.branch_current
        git_lib.unpushed(current_branch, "#{git_lib.remotes}/#{current_branch}")
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
        @logger = Logger.new(STDOUT)
        @logger.level = Logger::INFO
        command('diff', ['--numstat', '--shortstat', branch, remote_branch])
      end
      
    end
end