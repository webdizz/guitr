require 'rubygems'
require 'git'
require 'find'
require 'logger'
require 'guitr/git'
require 'optparse'
require 'ostruct'

module Guitr
  
  class GuitrRunner
    
    include GuitrGit
    
    attr_reader :repo_paths, :operation, :log
    
    def initialize
      @repo_paths = []
      @git_dir = '.git'
    end
    
    def run
      @options = OpenStruct.new
      @options.verbose = false
      @options.trace = false
      @options.operation = :status
      @options.isOperationSet = false;
      @options.log = nil
      @options.command = nil
      
      OptionParser.new do |opts|
        opts.banner = "Usage: guitr [options] [repository]"
        opts.separator ""
        
        opts.on("-v", "--verbose", "Run verbosely") do |v|
          @options.verbose = v
        end
        
        opts.on("-t", "--trace", "Run in trace mode") do |t|
          @options.trace = t
        end
        
        # Run pull
        opts.on("-p", "--pull", "Run --pull command to update all repositories") do |s|
          setOperation :pull
        end
        
        # Run unpushed
        opts.on("-u", "--unpushed", "Run --unpushed command to check commited but not pushed yet changes in repositories") do |s|
          setOperation :unpushed
        end
        
        # Run status command
        opts.on("-s", "--status", "Run --status command") do |s|
          setOperation :status
        end
        
        # Run exec command
        opts.on("-e", "--exec COMMAND", "Run COMMAND, for example guitr --exec date will output current date") do |c|
          setOperation :exec
          @options.command = c 
        end
        
        # Print an options summary.
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        
        # Print the version.
        opts.on_tail("-V", "--version", "Show version") do
          puts Guitr::VERSION
          exit
        end
        
        end.parse!
        
        @operation = @options.operation
        init_logger
        validate ARGV
        do_run
      end
      
      private
      
      def do_run
        res = ''
        @repo_paths.flatten.uniq.each do |repo|
          case @operation
            when :pull
            res = GitPull.new.run(repo)
            when :status
            res = GitStatus.new.run(repo)
            when :unpushed          
            res = GitUnpushed.new.run(repo)
            when :exec
              current_dir = Dir.pwd
              Dir.chdir repo
              res = system @options.command
              Dir.chdir current_dir
          end
        end
        res
      end
      
      def setOperation operation
        if !@options.isOperationSet
          @options.operation = operation
          @options.isOperationSet = true
        end
      end
      
      def validate(args)
        start_directory = './'
        last = @operation==:exec ? args[-2] : args.last
        if last.nil? || last.include?('--')
          @log.info 'Current directory will be used to start looking for git working copies.' if @log
        else
          start_directory = args.last	
        end
        
        if !File.exist? start_directory
          puts "Directory '#{start_directory}' does not exist."
          exit()
        end
        
        Find.find(start_directory) do |path|
          if path.include?(@git_dir) && !path.include?("#{@git_dir}/") && File.exist?(path) && File.directory?(path)
            @repo_paths << File.expand_path(path.gsub(@git_dir, ''))
          end
        end
        
        if @repo_paths.empty?
          puts "There are no repositories within '#{start_directory}' directory."
          exit()
        end
        
      end
      
      def init_logger
        create_logger(Logger::INFO) if @options.verbose
        create_logger(Logger::DEBUG) if @options.trace
      end
      
      def create_logger level
        @log = Logger.new STDOUT
        @log.level = level
        @options.log = @log
      end
      
    end
  end
