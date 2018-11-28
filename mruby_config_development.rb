$project_directory = File.expand_path(File.dirname(__FILE__))
$build_directory = "#{$project_directory}/build"


MRuby::Build.new do |conf|

  conf.build_dir = "#{$build_directory}/host"
  
  toolchain :gcc
  
  #conf.enable_debug
  
  #conf.gembox 'default'
  
end


MRuby::Toolchain.new('emscripten') do |conf|

  toolchain :clang
  
  conf.cc.command = 'emcc'
  conf.cxx.command = 'emcc'
  conf.linker.command = 'emcc'
  conf.archiver.command = 'emar'

end


MRuby::CrossBuild.new('app') do |conf|

  conf.build_dir = "#{$build_directory}/emscripten"
  
  toolchain :emscripten
  
  conf.compilers.each do |cxx|
    cxx.flags << '-Wall'
    cxx.flags << '-Wno-warn-absolute-paths'
    cxx.flags << '--bind'
    cxx.flags << '-O0'
    cxx.flags << '-g'
    cxx.flags << '-s DEMANGLE_SUPPORT=1'
  end
  
  conf.enable_debug
  
  conf.gem_clone_dir = "#{$build_directory}/gems"
  conf.gembox 'full-core'
  #conf.gem(core: 'mruby-print')
  #conf.gem(core: 'mruby-time')
  conf.gem("#{$project_directory}/resources/mruby_gems/mruby-bruby-bridge-interface")
  conf.gem(github: 'iij/mruby-regexp-pcre')
  
end


# we monkey patch the mruby build process to extract the list of gems
# this allows the esruby config.rb file to accept any format of gem listing that
#   mruby's build_config.rb accepts without reimplementing a bunch of mruby's
#   functionally
# the esruby build process will simply pass each gem entry without interpreting it
module MRuby
  module Gem
    class List
      
      old_check = instance_method(:check)
      define_method(:check) do |build|
        return_value = old_check.bind(self).call(build)
        if build.name == 'app'
          gem_paths = map { |gem| gem.dir }
          require 'json'
          File.write("#{$build_directory}/gem_paths.json", gem_paths.to_json)
        end
        return return_value
      end
      
    end
  end
end
