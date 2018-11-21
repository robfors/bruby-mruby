module BRuby
  class Build
    class Configuration
    
      attr_reader :ruby_sources
        :build_mode, :gems, :mruby_directory, :output_name
      
      attr_accessor :flags
      
      def initialize
        @project_directory = nil
        @mruby_directory = "/resources/mruby"
        @output_name = 'bruby-mruby-interpreter'
        @mruby_gems = []
        @flags = []
      end
      
      def project_directory
        raise "'project_directory' not set" unless @project_directory
        @project_directory
      end
      
      def project_directory=(new_project_directory)
        new_project_directory = File.expand_path(new_project_directory)
        raise "'project_directory' not found" unless File.directory?(new_project_directory)
        @project_directory = new_project_directory
      end
      
      def build_mode=(new_build_mode)
        new_build_mode = new_build_mode.to_s
        raise 'build mode not valid' unless ['production', 'development'].include?(new_build_mode)
        @build_mode = new_build_mode
      end
      
      def output_name=(new_output_name)
        raise ArgumentError, "'new_output_name' must respond to #to_s" unless new_output_name.respond_to?(:to_s)
        @output_name = new_output_name.to_s
      end
      
      def mruby_gem(arg)
        @gems << arg
      end
    
    end
  end
end
