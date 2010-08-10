require 'git'
require 'timeout'

module Guitr
  module GuitrGit
    
    class GitStatus
      
      attr_reader :git
      
      def run(repo, options = {})
        @git = Git.open(repo, options)
        res = @git.lib.status
        if !res.empty?
          puts 
          res = "Status for #{repo}\n"+res
          res = res.gsub('??', ' U')
          puts res
          puts
        end
        
        res
      end
      
    end
    
    class GitUnpushed
      
      attr_reader :git
      
      def run(repo, options={})
        @git = Git.open(repo, options)
        git_lib = @git.lib
        current_branch = git_lib.branch_current
        remote = git_lib.remotes
        if remote.empty?
          puts "There is no remote for '#{repo}'."
          return ''
        end
        res = ''
        begin
          res = git_lib.unpushed(current_branch, "#{remote}/#{current_branch}")
          if !res.empty?
            puts 
            puts "Unpushed commits '#{repo}': " 
            puts res
            puts 
          end
        rescue Git::GitExecuteError => e
          puts "Unable to check unpushed commits '#{repo}' #{e.message}"
        end
        
        res
      end
      
    end
    
    class GitPull
      
      attr_reader :git
      
      def run(repo, options = {})
        @git = Git.open(repo, options)
        begin
          puts
          res = @git.lib.pull
          res = "Going to pull #{repo}\n"+res if !res.empty?
          res = '' if res.include?("up-to-date")
          puts res
          res
        rescue Git::GitExecuteError => e
          puts "Unable to pull for #{repo}: #{e.message}"
        end
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
    
    def pull
      command('pull')
    end
    
  end
end
