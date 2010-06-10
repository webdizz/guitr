require 'rubygems'
require 'git'
require 'find'
require 'logger'
require 'guitr/git'

module Guitr
  
  class GuitrRunner
    
    attr_reader :repo_paths, :operation, :log
    
    def initialize 
      @operational_args = ['--status', '--pull']
      @acceptable_args = [:verbose, :trace] << @operational_args
      @acceptable_args = @acceptable_args.flatten
      @repo_paths = []
      @git_dir = '.git'
      @usage = '$ guitr --status|--pull path_to_git_repo(s) '
      @options = {}
    end
    
    def run(args)
      validate args
      @repo_paths.flatten.uniq.each do |repo|
        case @operation.to_sym
          when :pull
          git_pull(repo)
          when :status
          GuitrGit::GitStatus.new.run(repo, @options)
        end
      end
    end
    
    def validate(args)
      @operation = :status;
      args.each do |arg|
        @operation = arg.gsub('--', '') if @operational_args.include?(arg)
      end
      
      start_directory = './'
      last = args.last
      if last.nil? || last.include?('--')
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
      
      if @repo_paths.empty?
        puts "There are no repositories within '#{start_directory}' directory."
        exit(0)
      end
      
      init_logger(args)
      
    end
    
    def init_logger args
      args.each do |arg|
        arg = arg.gsub('--', '')
        create_logger(Logger::INFO) if arg.to_sym == :verbose
        create_logger(Logger::DEBUG) if arg.to_sym == :trace
      end
    end
    private :init_logger
    
    def create_logger level
      @log = Logger.new STDOUT
      @log.level = level
      @options[:log] = @log
    end
    private :create_logger
    
    def git_pull repo
      puts
      puts "Going to pull #{repo}"
      g = Git.open(repo, @options)
      g.pull
    end
    private :git_status
    
  end
end
