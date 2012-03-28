# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "combo_box"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brice Texier"]
  s.date = "2012-03-28"
  s.description = "Adds helpers for Rails views and controller in order to manage 'dynamic select'. It uses jQuery UI as support for inobtrusive use in forms. It's not the classic Autocompleter, its use is limited to belongs_to reflections."
  s.email = "brice.texier@ekylibre.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "VERSION",
    "lib/assets/javascripts/combo_box.js",
    "lib/assets/stylesheets/combo_box.css",
    "lib/combo_box.rb",
    "lib/combo_box/action_controller.rb",
    "lib/combo_box/engine.rb",
    "lib/combo_box/generator.rb",
    "lib/combo_box/helpers.rb",
    "lib/combo_box/helpers/form_tag_helper.rb",
    "lib/combo_box/railtie.rb"
  ]
  s.homepage = "http://github.com/burisu/combo_box"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Adds the combo_box control in Rails 3 based on jQuery UI"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
    else
      s.add_dependency(%q<rails>, ["~> 3"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
  end
end

