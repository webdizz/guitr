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
    
  end
end

module Git
  
    class Lib
      
      def status
        command('status', ['--porcelain'])
      end
      
    end
end