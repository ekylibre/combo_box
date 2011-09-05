# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "combo_box"
  gem.homepage = "http://github.com/burisu/combo_box"
  gem.license = "MIT"
  gem.summary = "Adds the combo_box control in Rails 3 based on jQuery UI"
  gem.description = "Adds helpers for Rails views and controller in order to manage 'dynamic select'. It uses jQuery UI as support for inobtrusive use in forms. It's not the classic Autocompleter, its use is limited to belongs_to reflections."
  gem.email = "brice.texier@ekylibre.org"
  gem.authors = ["Brice Texier"]
  gem.files = `git ls-files lib`.split(/\n/)+['Gemfile', 'MIT-LICENSE', 'README.rdoc', 'VERSION']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ComboBox #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
