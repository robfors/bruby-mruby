# This file sets up the build environment for a webruby project.
Extraneous::Module::Specification.new do |spec|

  # set the path of the esruby project
  # all other paths specified in this config file will be expanded
  #   relative to this path
  spec.project_directory = File.dirname(__FILE__)

  spec.name = 'bruby-bridge-interface'

  spec.build_mode = 'development'

  spec.output_path = '../../../build/bruby-bridge-interface.js'
  
  # list as many ruby source files as you want
  # keep in mind they will be executed in the order you list them
  spec.source(path: 'rb/class.rb', type: 'ruby')
  spec.source(path: 'rb/object.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/js_interface.rb', type: 'ruby')
  spec.source(path: 'rb/bruby_bridge/rb_interface.rb', type: 'ruby')
  
  spec.source(path: 'js/bruby_bridge.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/js_interface.js', type: 'java_script')
  spec.source(path: 'js/bruby_bridge/rb_interface.js', type: 'java_script')
  
  spec.source(path: 'js/setup.js', type: 'java_script')

  #dependency mruby-bruby-bridge-interface
  #  spec.license = 'MIT'
  #spec.author  = 'Rob Fors'
  #spec.summary = 'low level minimalist interface between the javascript and ruby environment'
  
end
