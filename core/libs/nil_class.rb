class NilClass
  # nil can be considered blank/empty/void and without any element
  def any?; false; end
  def blank?; true; end
  alias :empty? :blank?
  alias :void?  :blank?
end # NilClass