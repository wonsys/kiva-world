require 'rubygems'

dir  = File.expand_path(File.dirname(__FILE__))
root = File.expand_path(File.join(dir, '..'))
require File.join(dir, 'fetcher')
require File.join(dir, 'templater')

module Kiva
  API_URL = 'http://api.kivaws.org/v1'
  
  class << self
    public # PUBLIC class methods
    
    # Fetches data
    def fetch(type, what)
      query = Kiva::Fetcher.load(url(type, what))
      data = query[type.to_s]
      pages = query['paging']['pages'] < 5 ? query['paging']['pages'] : 5
      2.upto(pages) do |page|
        query = Kiva::Fetcher.load(url(type, what, page))
        data += query[type.to_s]
      end
      data
    end
    
    private # PRIVATE class methods
    
    def url(type, what, page=1)
      url_base = "#{API_URL}/#{type}"
      url_path = case type
      when :loans
        case what
        when :newest then "newest.json?page=#{page}"
        else "search.json?status=#{what}&sort_by=newest&page=#{page}"
        end
      end
      "#{url_base}/#{url_path}"
    end
  end # Kiva (self)
end # Kiva

# kiva map
type = :kiva_map
loans = {'fundraising'  => Kiva.fetch(:loans, :fundraising),
         'funded'       => Kiva.fetch(:loans, :funded),
         'in_repayment' => Kiva.fetch(:loans, :in_repayment),
         'paid'         => Kiva.fetch(:loans, :paid)} # 'defaulted'    => Kiva.fetch(:loans, :defaulted)
page = Kiva::Templater.new(type, :loans => loans).page
File.open(File.join(root, type.to_s, 'public', 'index.html'), 'w+') do |file|
  puts 'Writing file for kiva map...'
  file.flock(File::LOCK_EX)
  file.write(page)
end
puts 'Kiva Map regenerated!'

# kiva people