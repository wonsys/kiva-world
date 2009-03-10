class Hash
  public # PUBLIC instance methods
  
  # Performs a deep freezing
  #
  def deep_freeze
    self.each { |k, v| v.deep_freeze if v.respond_to?(:deep_freeze) }
    self.freeze
  end
  
  # Returns a Hash with only the pairs identified by +keys+
  #
  # i.e. { :a => 1, :b => 2, :c => 3 }.only(:a)
  #  => { :a => 1 }
  #
  def only(*keys)
    self.reject {|k,v| !keys.include?(k)}
  end
  
  # Overrides some keys (alias of merge method)
  #
  # i.e. { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
  #  => { :a => 4, :b => 2, :c => 3 }  
  # 
  alias :with :merge
  
  alias :old_invert :invert
  def invert(overwrite=true)
    if overwrite
      self.old_invert
    else
      before   = self.length
      inverted = self.old_invert
      (before == inverted.length) ? inverted : nil
    end
  end
end # Hash