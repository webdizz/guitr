#!/usr/bin/env ruby
 
require 'rubygems'
require 'git'
require 'find'
require 'logger'

module Guitr
  
  def status repo
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
  
  def pull repo
    puts
    puts "Going to pull #{repo}"
    g = Git.open(repo, :log => Logger.new(STDOUT))
    g.pull
  end
  
end

include Guitr
if __FILE__ == $0
  
  working_dir = ARGV[0]
  
  if !working_dir
    puts "You need to define path to folder with projects or a project as an argument."
    puts
    puts '$ ruby guitr path_to_project'
    puts
    Thread.current.exit
  end
  
  if !File.exist? working_dir
    puts "Directory '#{working_dir}' does not exist."
    Thread.current.exit
  end
  
  repos = []
  
  Find.find(working_dir) do |path|
    if path.include?('.git') && !path.include?('.git/') && File.exist?(path) && File.directory?(path)
      repos << path.gsub('.git', '')
    end
    
  end
  
  repos.flatten.uniq.each do |repo|
    status(repo) if !ARGV[1] || ARGV[1]=='status'
    pull(repo) if ARGV[1]=='pull'
  end
  
end

