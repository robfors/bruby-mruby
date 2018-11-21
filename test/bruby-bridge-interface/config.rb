# This file sets up the build environment for a webruby project.
Extraneous::Module::Specification.new do |spec|

  # set the path of the esruby project
  # all other paths specified in this config file will be expanded
  #   relative to this path
  spec.project_directory = File.dirname(__FILE__)

  spec.name = 'bruby-bridge-interface-test'

  spec.output_path = '../../build/test/www/bruby-bridge-interface-test.js'

  spec.build_mode = 'development'
  
  # list as many ruby source files as you want
  # keep in mind they will be executed in the order you list them
  spec.source(path: 'test.rb', type: 'ruby')
  spec.source(path: 'test.js', type: 'java_script')

  spec.source(path: 'lib/class.rb', type: 'ruby')
  spec.source(path: 'lib/object.rb', type: 'ruby')
  spec.source(path: 'lib/js_interface.rb', type: 'ruby')
  
  spec.source(path: 'lib/rb_interface.js', type: 'java_script')
  
  #dependency mruby-bruby-bridge-interface
  #  spec.license = 'MIT'
  #spec.author  = 'Rob Fors'
  #spec.summary = 'low level minimalist interface between the javascript and ruby environment'
  
end
