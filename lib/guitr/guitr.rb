require 'rubygems'
require 'git'
require 'find'
require 'logger'

module Guitr
  
  class GuitrRunner
    
    def initialize 
      @acceptable_args = ['--status', '--pull'] 
      @repo_paths = []
      @git_dir = '.git'
      @usage = '$ guitr --status|--pull path_to_git_repo(s) '
    end
    
    def run(args)
      validate args
      @repo_paths.flatten.uniq.each do |repo|
        case @operation.to_sym
          when :pull
          git_pull(repo)
          when :status
          git_status(repo)
        end
      end
    end
    
    def validate(args)
      @operation = :status;
      args.each do |arg|
        @operation = arg.gsub('--', '') if @acceptable_args.include?(arg)
      end
      
      if @operation.to_s.empty?
        puts 'You need to define one of acceptable operations --status or --pull'
        exit(0)
      end
      
      start_directory = './'	
      if args.last.nil? || args.last.include?('--')
        puts 'Current directory will be used to start looking for git working copies.'
      else
        start_directory = args.last	
      end
      
      
      if !File.exist? start_directory
        puts "Directory '#{start_directory}' does not exist."
        exit(0)
      end
      
      Find.find(start_directory) do |path|
        if path.include?(@git_dir) && !path.include?("#{@git_dir}/") && File.exist?(path) && File.directory?(path)
          @repo_paths << path.gsub(@git_dir, '')
        end
      end
      
    end
    
    def git_status repo
      log = Logger.new(STDOUT)
      log.level = Logger::WARN
      g = Git.open(repo, :log => log)
      puts 
      puts "Status for #{repo}"
      puts '======================<<<<<<<<<<'
      puts 'You have next untracked/modified/deleted/added files:' if !g.status.changed
      g.status.each{|file|
        puts "U  #{file.path}" if file.untracked
        puts "M  #{file.path}" if file.type == 'M'
        puts "D  #{file.path}" if file.type == 'D'
        puts "A  #{file.path}" if file.type == 'A'
      }
      puts '======================>>>>>>>>>>>'
    end
    private :git_status
    
    def git_pull repo
      puts
      puts "Going to pull #{repo}"
      g = Git.open(repo, :log => Logger.new(STDOUT))
      g.pull
    end
    private :git_status
    
  end
end
