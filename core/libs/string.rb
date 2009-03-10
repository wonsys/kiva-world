class String
  public # PUBLIC instance methods
  
  # Returns the first char (means true) if there is at least 1 char (no blank string)
  def any?
    self[0]
  end
  
  # Returns true if the string is blank (no char)
  def blank?
    !self[0]
  end
  
  # Returns true if the first char of the string
  def capitalized?
    (self[0] >= 65 && self[0] <= 90) if self.any? # 65 => A, 90 => Z
  end
  
  # Deserializes a string serialized with Array#serialize (or other)
  # i.e. "|a|1| b| |".deserialize # => ["", "a", "1", " b", " ", ""]
  # 
  # Takes four options (it will run on the array after splitting the string):
  # * :strip: if true, calls strip method (removes whitespace before and after the text string) for every chunk of text (default to false)
  # * :force_nil: if true, sets to nil every blank chunk of text (default to false)
  # * :compact: if true, removes all nil objects (default to false)
  # * :uniq: if true removes all duplicated elements (default to false)
  #
  def deserialize(separator='|', options={})
    options = {:strip     => false,
               :force_nil => false,
               :compact   => false,
               :uniq      => false}.merge(options) # merges options
    array = self.split(separator.to_s, self.size).map do |chunk| # splits string into chunks
      chunk.strip! if options[:strip] # calls strips method for every chunk of text (if options[:strip] is true)
      (options[:force_nil] && chunk.blank?) ? nil : chunk # sets nil object if a chunk of text is blank (if options[:force_nil] is true)
    end
    array.compact! if options[:compact] # removes nil objects (if options[:compact] is true)
    options[:uniq] ? array.uniq : array # removes all duplicated elements (if options[:uniq] is true)
  end
  
  # Returns how many times the string matched the given pattern
  def how_many(pattern)
    self.scan(pattern).length
  end
  
  # Used to indent Here-Documents
  #
  # i.e.  str = <<end_of_string.margin
  #              |  aaa
  #              |a
  #              |  aa
  #       end_of_string
  #
  # => "  aaa\na  \naa\n"
  #
  def margin
    self.replace((self.deserialize("\n", :strip => true).map {|line| line.sub('|','')}).serialize("\n"))
  end
  
  # Returns a value in cents for a given string number
  # i.e. 100,3 
  #   => 10030
  #
  def to_cents
    value = self.dup
    value.strip! # removes whitespace from borders
    dots   = value.how_many('.')
    commas = value.how_many(',') # commas is not mathematically correct
    case dots
    when 0
      value.gsub!(',','') if (commas > 1)
    when 1
      if commas == 1
        (value.rindex('.') > value.rindex(',')) ? value.gsub!(',','') : value.gsub!('.','')
      else
        value.gsub!(',','') unless commas.zero?
      end
    else # more then one
      (commas > 1) ? value.gsub!(',','') : value.gsub!('.', '')
    end
    value.gsub!(',', '.')
    (value.to_f * 100).round
  end
end # String