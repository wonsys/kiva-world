require 'erubis'

module Kiva
  class Templater
    public # PUBLIC instance methods
    
    attr_reader :page, :files
    
    def generate_css_file
      generate_file('css')
    end
    
    def generate_js_file
      generate_file('js')
    end
    
    def initialize(type, params={})
      @type  = type.to_s
      @page  = Erubis::Eruby.new(File.read(path('index.erb.html'))).result(params.merge(:this => self))
      @files = {:text => [{:name => 'index.html',   :content => @page},
                          {:name => "#{@type}.css", :content => generate_css_file},
                          {:name => "#{@type}.js",  :content => generate_js_file}],
                :binary => path('assets')}
    end

    private # PRIVATE instance methods
    
    def generate_file(ext)
      merged = ''
      Dir.glob(File.join(path, "*.#{ext}")).each do |file|
        merged << "/* === #{File.basename(file)} === */\n\n"
        merged << File.read(file)
        merged << "\n\n"
      end
      merged
    end
    
    def path(file='')
      File.join(Kiva::Core.path(:templates), @type, file)
    end
  end # Templater
end # Kiva