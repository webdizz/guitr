begin
  require 'spec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  gem 'git'
  require 'spec'
  require 'git'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'guitr'
require 'guitr/guitr'
require 'guitr/git'
require 'guitr/exceptions'
