# This file sets up the build environment for a webruby project.
Extraneous::Module::Specification.new do |spec|

  # set the path of the esruby project
  # all other paths specified in this config file will be expanded
  #   relative to this path
  spec.project_directory = File.dirname(__FILE__)

  spec.name = 'bruby-mruby-print'

  spec.build_mode = 'development'

  spec.output_path = '../../../build/bruby-mruby-print.js'
  
  # list as many ruby source files as you want
  # keep in mind they will be executed in the order you list them
  spec.source(path: 'rb/kernel.rb', type: 'ruby')
  
  #dependency mruby-bruby-bridge-interface
  #  spec.license = 'MIT'
  #spec.author  = 'Rob Fors'
  #spec.summary = 'low level minimalist interface between the javascript and ruby environment'
  
end
