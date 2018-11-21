task :default => :build

task :build do
  ruby "build_development.rb"
end

task :clean do
  rm_rf "build"
end

task :test => :build do
  mkdir_p "build/test/www"
  cp "test/resources/extraneous/bin/extraneous-0.0.0.js", "build/test/www/extraneous.js"
  cp "build/bruby-mruby.js", "build/test/www/bruby-mruby.js"
  RakeFileUtils.sh("extraneous build test/bruby-bridge-interface/config.rb")
  cp "test/resources/index.html", "build/test/www/index.html"
  sh "ruby -run -e httpd build/test/www -p 2222"
end