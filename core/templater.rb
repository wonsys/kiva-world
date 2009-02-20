require 'erubis'

module Kiva
  class Templater
    public # PUBLIC instance methods
    
    attr_reader :page
    
    def css_include_tag(*files)
      css = "<style type=\"text/css\" media=\"all\">\n"
      files.each do |file|
        css << File.read(path("#{file}.css"))
      end
      css << "\n</style>"
    end
    
    def initialize(type, params={})
      @type = type.to_s
      @page = Erubis::Eruby.new(File.read(path('index.erb.html'))).result(params.merge(:this => self))
    end
    
    def js_include_tag(*files)
      js = "<script type=\"text/javascript\">\n"
      files.each do |file|
        js << File.read(path("#{file}.js"))
      end
      js << "\n</script>"
    end
    
    private # PRIVATE instance methods
          
    def path(file)
      File.join(File.expand_path(File.dirname(__FILE__)), 'templates', @type, file)
    end
  end # Templater
end # Kiva