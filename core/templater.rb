require 'erubis'

module Kiva
  class Templater
    public # PUBLIC instance methods
    
    attr_reader :files
    
    def generate_css_file
      generate_file('css')
    end
    
    def generate_js_file
      generate_file('js')
    end
    
    def initialize(type, params={})
      @type  = type.to_s
      page   = Erubis::Eruby.new(File.read(path('index.erb.html'))).result(params.merge(:this => self))
      @files = [{:name => 'index.html',   :content => page},
                {:name => 'kiva_map.css', :content => generate_css_file},
                {:name => 'kiva_map.js',  :content => generate_js_file}]
    end

    private # PRIVATE instance methods
    
    def generate_file(ext='css')
      merged = ''
      Dir.glob(File.join(path, "*.#{ext}")).each do |file|
        merged << "/* === #{File.basename(file)} === */\n\n"
        merged << File.read(file)
        merged << "\n\n"
      end
      merged
    end
    
    def path(file='')
      File.join(File.expand_path(File.dirname(__FILE__)), 'templates', @type, file)
    end
  end # Templater
end # Kiva