$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Guitr
  VERSION = '0.0.5'
end

require 'guitr/guitr'
require 'guitr/exceptions'