class Time
  
  SYMBOLS_TO_CODE = {
    :day    => '%d',
    :month  => '%m',
    :year   => '%Y',
    :hour   => '%H',
    :minute => '%M',
    :second => '%S' }.freeze

  MONTHS_SHORT = {
    :en => %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec},
    :it => %w{Gen Feb Mar Apr Mag Giu Lug Ago Set Ott Nov Dic}}.deep_freeze
  
  MONTHS_LONG = {
    :en => %w{January February March April May June July August September October November December}}.deep_freeze
  
  public # PUBLIC instance methods
  
  # Formats time to string using only the date. Indeed, it calls formatted on a Date object
  # Takes two options:
  # * :order: array containing :day, :month and :year in the desired order (defaults to [:day, :month, :year])
  # * :separator: what should go between the elements (defaults to '/')
  # * :months: could be setted to :long or :shor to show worded months (defaults to nil)
  #
  def formatted(options={})
    options = {:order     => [:day, :month, :year],
               :separator => '/',
               :months    => nil}.merge(options)
    codes   = options[:order].map {|o| SYMBOLS_TO_CODE[o]}.compact.uniq
    text    = codes.serialize(options[:separator])
    text    = self.strftime(text)
    if options[:months]
      array = text.deserialize(options[:separator])
      index = options[:order].index(:month)
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
  
  # Formats time to string
  # Takes below options:
  # * :order: the order in which date and time should be returned (defaults to [:date, :time])
  # * :separator: what should go between time and date blocks (defaults to ' ')
  # * :time_order: array containing :hour, :minute and :second in the desired order (defaults to [:hour, :minute, :second])
  # * :time_separator: what should go between the time elements (defaults to ':')
  # * :date_order: array containing :day, :month and :year in the desired order (defaults to [:day, :month, :year])
  # * :date_separator: what should go between the date elements (defaults to '/')
  #
  def formatted_with_time(options={})
    options = {:order      => [:date, :time],
               :time_order => [:hour, :minute, :second],
               :date_order => [:day, :month, :year],
               :date_separator => '/',
               :time_separator => ':',
               :separator => ' '}.merge(_options)
    date    = self.formatted(:order => options[:date_order], :separator => options[:date_separator])
    codes   = options[:time_order].map {|o| SYMBOLS_TO_CODE[o]}.compact.uniq
    time    = codes.join(options[:time_separator])
    blocks  = []
    options[:order].each do |o|
      case o.to_sym
        when :date
          blocks << date
        when :time
          blocks << time
      end
    end
    text = blocks.join(options[:separator])
    self.strftime(text)
  end
  
  # # Returns short version of time:
  # # * if date is today, returns hh:mm
  # # * if date is yesterday, returns 'yesterday'
  # # * if less than a year ago mmm dd
  # # * else mmm yyyy
  # #
  # def short(lang=:en)
  #   date = self.to_date
  #   if(date == Date.today)
  #     self.strftime('%H:%M')
  #   elsif(date == 1.day.ago.to_date)
  #     YESTERDAY[lang]
  #   elsif(self.year == Time.now.year)
  #     "#{self.day} #{MONTHS_SHORT[lang][self.month - 1]}"
  #   else
  #     "#{MONTHS_SHORT[lang][self.month + 1]} #{self.year}"
  #   end
  # end
end # Time