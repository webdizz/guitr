require 'rubygems'
gem 'hoe', '>= 2.1.0'
gem 'git', '>=1.2.5'

require 'hoe'
require 'git'
require 'fileutils'
require './lib/guitr'

Hoe.plugin :newgem
Hoe.plugin :git

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'guitr' do
  self.developer 'webdizz', 'webdizz@gmail.com'
  self.post_install_message = "
  Usage:  
  guitr [options] [path_to_repo if not specified current directory will be used]
  
  Options:
  --status    # default command to invoke, echos result of the 'git status'
  --pull      # performs 'git pull' against all found repositories
  --unpushed  # checks whether there are commits need to be pushed
  --verbose   # echos INFO level logs
  --trace     # echos DEBUG level logs
    
  For details go to http://webdizz.name/posts/guitr
  "
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [
    ['git','>= 1.2.5'],
    ['hoe', ">= #{Hoe::VERSION}"]
  ]

end

require 'newgem/tasks'