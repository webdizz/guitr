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
  self.post_install_message = '$ guitr --status|--pull [path_to_repo]  '
  self.rubyforge_name       = self.name # TODO this is default value
  self.extra_deps         = [
    ['git','>= 1.2.5'],
    ['hoe', ">= #{Hoe::VERSION}"]
  ]

end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

# TODO - want other tests/tasks run by default? Add them to the list
# remove_task :default
# task :default => [:spec, :features]
