require 'erubis'
require 'fileutils'
require 'forwardable'
require 'rake'
require 'json'



# def load_gems
#   gem_paths.each do |gem_path|
#     esruby_spec_path = "#{gem_path}/esruby_gem"
#     load(esruby_spec_path) if File.file?(esruby_spec_path)
#   end
#   nil
# end
  
  # def gem_paths
  #   JSON.parse(File.read(gem_paths_file))
  # end
  
  # def gem_paths_file
  #   "#{build_directory}/gem_paths.json"
  # end
  

# production
#   -O2
#   -g0
#   --closure 1"
#args << %q{-s "BINARYEN_METHOD='native-wasm,asmjs'"}
# ENV["EMCC_CLOSURE_ARGS"] = "--language_in=ECMASCRIPT6" #possibly allow setting output: --language_out=ECMASCRIPT6
    #  sh "java -jar #{PROJECT_DIRECTORY}/emsdk/emscripten/incoming/third_party/closure-compiler/compiler.jar --js #{build.absolute_build_directory}/output.js --js_output_file #{build.absolute_output}"
    #else
      #output_file_extensions = ["asm.js", "js", "js.mem", "wasm"]
      #output_file_extensions = ["js"]
      #output_file_extensions.each do |extension|
      #  FileUtils.cp("#{build_directory}/#{output_name}.#{extension}", "#{output_directory}/#{output_name}.#{extension}")
      #end
    #end
    #--language_in=ECMASCRIPT6
  end


project_directory = File.expand_path(File.dirname(__FILE__))

build_directory = "#{project_directory}/build"
FileUtils.mkdir_p(build_directory)

ENV["MRUBY_CONFIG"] = "#{project_directory}/mruby_config_development.rb"

mruby_directory = "#{project_directory}/resources/mruby"

# build mruby lib
Dir.chdir(mruby_directory) { FileUtils.sh "rake" }

options = []
options << "-std=c++11"
options << "--bind"
options << "#{$mruby_directory}/include"
options << "-o #{$build_directory}/main.o"
options << "-lm"
options << "--post-js #{resources/js/bruby-mruby-interpreter.js}"
options << "-O0"
options << "-g"
options << "-s DEMANGLE_SUPPORT=1"
options << "-s ALLOW_MEMORY_GROWTH=1"
options << "-s ASSERTIONS=2"
options << "-s WASM=0"
options << "-s DISABLE_EXCEPTION_CATCHING=0"
FileUtils.sh "emcc --bind #{cxx_include_argument} -o #{output_directory}/#{output_name}.js #{build_directory}/ruby_main.o #{build_directory}/main.o #{build_directory}/emscripten/lib/libmruby.a -lm #{js_arguments} #{optimization_argument} #{closure_argument} #{debug_argument} #{flags} -s ALLOW_MEMORY_GROWTH=1 -s ASSERTIONS=2 #{args.join(" ")}"
