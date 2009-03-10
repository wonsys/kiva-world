class Array
  public # PUBLIC instance methods
  
  # Calculates average of values
  #
  def avg
    avg = self.inject(0) {|sum, x| sum += x} / self.size.to_f
    avg.nan? ? 0.0 : avg # NaN is true when the float is not a valid one
  end
  
  # Performs a deep freezing
  #
  def deep_freeze
    self.each { |part| part.deep_freeze if part.respond_to?(:deep_freeze) }
    self.freeze
  end
  
  # Returns a subset of the Array with x random elements
  #
  def random(x)
    return [] if(x = x.to_i) <= 0 # forces x to be an integer number
    self.shuffle[0...x]
  end
  
  # Replace the current array with a subset of it with x random elements
  #
  def random!(x)
    random_array = self.random(x)
    random_array.empty? ? nil : self.replace(random_array)
  end
  
  # Serializes an array
  # i.e. ["","a", 1, " b"].serialize # => "|a|1| b"
  #
  def serialize(separator='|')
    self * separator.to_s
  end
  
  # Shuffles Array
  #
  def shuffle
    self.sort_by {|elem| Kernel.rand}
  end
  
  # Shuffles Array
  #
  def shuffle!
    self.replace(self.shuffle)
  end
end # Array