class Date
  SYMBOLS_TO_CODE = {:day => '%d', :month => '%m', :year => '%Y'}.freeze

  SYMBOLS_ORDER = {
    :en => [:month, :day, :year],
    :it => [:day, :month, :year],
    :jp => [:year, :month, :day]}.deep_freeze

  MONTHS_SHORT = {
    :en => %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec},
    :it => %w{Gen Feb Mar Apr Mag Giu Lug Ago Set Ott Nov Dic}}.deep_freeze

  MONTHS_LONG = {
    :en => %w{January February March April May June July August September October November December}}.deep_freeze

  public # PUBLIC instance methods

  # Formats date to string.
  # Takes two options:
  # * :order: array containing :day, :month and :year in the desired order (defaults to nil)
  # * :separator: what should go between the elements (defaults to '/')
  # * :international: :en, :it or :jp (defaults to ':jp'); it'll be overwritten by order option if it's setted
  # * :months: could be setted to :long or :shor to show worded months (defaults to nil)
  #
  # Note: It doesn't use Time#formatted due a problem with date range in Time class
  #
  def formatted(options={})
    options = {:order         => nil,
               :separator     => '/',
               :international => :jp,
               :months        => nil}.merge(options)
    order   = options[:order] ? options[:order] : SYMBOLS_ORDER[options[:international]]
    codes   = order.map {|o| SYMBOLS_TO_CODE[o]}.compact.uniq
    text    = codes.serialize(options[:separator])
    text    = self.strftime(text)
    if options[:months]
      array = text.deserialize(options[:separator])
      index = order.index(:month)
      month = array[index].to_i - 1
      array[index] = case options[:months]
      when :short then MONTHS_SHORT[:en][month]
      when :long then MONTHS_LONG[:en][month]
      else array[index]
      end
      array.serialize(options[:separator])
    else
      text
    end
  end
end # Date