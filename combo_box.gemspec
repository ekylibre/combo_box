# encoding: utf-8
Gem::Specification.new do |s|
  s.name = "combo_box"
  File.open("VERSION", "rb") do |f|
    s.version = f.read
  end
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.author = "Brice Texier"
  s.email  = "burisu@oneiros.fr"
  s.summary = "Adds the combo_box control in Rails 3 based on jQuery UI"
  s.description = "Adds helpers for Rails views and controller in order to manage 'dynamic select'. It uses jQuery UI as support for inobtrusive use in forms. It's not the classic Autocompleter, its use is limited to belongs_to reflections."
  s.extra_rdoc_files = ["LICENSE", "README.rdoc" ]
  s.test_files = `git ls-files test`.split("\n") 
  exclusions = [ "#{s.name}.gemspec", ".travis.yml", ".gitignore", "Gemfile", "Gemfile.lock", "Rakefile"]
  s.files = `git ls-files`.split("\n").delete_if{|f| exclusions.include?(f)}
  s.homepage = "http://github.com/burisu/combo_box"
  s.license = "MIT"
  s.require_path = "lib"

  add_runtime_dependency = (s.respond_to?(:add_runtime_dependency) ? :add_runtime_dependency : :add_dependency)
  s.send(add_runtime_dependency, "rails", [">= 3.1"])
  s.send(add_runtime_dependency, "jquery-rails", [">= 0"])
end
