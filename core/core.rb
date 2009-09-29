module Kiva
  API_URL = 'http://api.kivaws.org/v1'
  
  module Core
    DEBUG = true
    DIR   = File.expand_path(File.dirname(__FILE__))
    ROOT  = File.expand_path(File.join(DIR, '..'))
    
    class << self
      public # PUBLIC class methods
      def path(type=:root)
        case type
        when :root then ROOT
        when :core then DIR
        when :templates then File.join(DIR, 'templates')
        when :models    then File.join(DIR, 'models')
        when :libs      then File.join(DIR, 'libs')
        when :kiva_map, :kiva_people, :kiva_stats
          File.join(ROOT, "#{type}", 'public')
        end
      end
      
      def url_for(what, page=nil, id=nil)
        url = case what
        when :all_loans     then "#{Kiva::API_URL}/loans/search.json?sort_by=newest"
        when :all_partners  then "#{Kiva::API_URL}/partners.json"
        when :lenders       then "#{Kiva::API_URL}/loans/#{id}/lenders.json"
        when :lender        then "#{Kiva::API_URL}/lenders/#{id}.json"
        when :loan          then "#{Kiva::API_URL}/loans/#{id}.json"
        end
        url = page ? (url.index('?') ? "#{url}&page=#{page}" : "#{url}?page=#{page}") : url
        url.index('?') ? "#{url}&app_id=com.kivaworld" : "#{url}?app_id=com.kivaworld"
      end
      
      def url_info(what, id=nil)
        raise "Error: WRONG type (#{what})" unless(url = url_for(what, nil, id))
        raise "Error: WRONG url (#{url})" unless(data = Kiva::Fetcher.load(url))
        paging = data['paging']
        pages = paging ? paging['pages'] : 1
        puts "Total pages found for #{what}: #{pages}" if Kiva::Core::DEBUG
        info = paging ? {:url => url, :size => paging['total'], :page_size => paging['page_size'], :pages => pages} : {:url => url, :size => 1, :page_size => 1, :pages => pages}
        info[:data] = data if pages == 1
        info
      rescue => e
        puts "WARNING: #{e}"
        nil
      end
    end # Core (self)
  end # Core
end # Kiva

require File.join(Kiva::Core.path(:libs), 'init')
require 'rubygems'
require 'fileutils'
require File.join(Kiva::Core.path(:core), 'fetcher')
require File.join(Kiva::Core.path(:core), 'templater')
require File.join(Kiva::Core.path(:models), 'init')

module Kiva
  
  class << self
    public # PUBLIC class methods
    
    # Fetches data
    def fetch(type, what=nil)
      type_to_s = type.to_s
      case type
      when :loans
        query = Kiva::Fetcher.load(url(type, what))
        data = query[type_to_s]
        pages = query['paging']['pages'] < 5 ? query['paging']['pages'] : 5
        2.upto(pages) do |page|
          query = Kiva::Fetcher.load(url(type, what, page))
          data += query[type_to_s]
        end
        data
      when :all then Kiva::Loan.update_all!
      end
    end

    # Regenerates files
    def regenerate!(type, all=false)
      params = {}
      case type
      when :kiva_map
        params = {:loans => { 'fundraising'  => Kiva.fetch(:loans, :fundraising),
                              'funded'       => Kiva.fetch(:loans, :funded),
                              'in_repayment' => Kiva.fetch(:loans, :in_repayment),
                              'paid'         => Kiva.fetch(:loans, :paid)}}
                            # 'defaulted'    => Kiva.fetch(:loans, :defaulted)
      when :kiva_people
        params = {:lenders => Kiva::Lender.get_random(200)}
      end

      puts "Writing files for #{type}..." if Kiva::Core::DEBUG

      if all # regenerates all files (html, css, js, images, etc..)
        files = Kiva::Templater.new(type, params).files
        FileUtils.copy_entry(files[:binary], Kiva::Core::path(type))
        files[:text].each do |file|
          File.open(File.join(Kiva::Core::path(type), file[:name]), 'w+') do |f|
            f.flock(File::LOCK_EX)
            f.write(file[:content])
          end
        end
      else # regenerates the index page only
        page = Kiva::Templater.new(type, params).page
        File.open(File.join(Kiva::Core::path(type), 'index.html'), 'w+') do |f|
          f.flock(File::LOCK_EX)
          f.write(page)
        end
      end

      puts "#{type} regenerated!" if Kiva::Core::DEBUG

    rescue => e
      puts "An error occour when regenerating #{type}: #{e}\n#{e.backtrace.join("\n")}"
      exit(1) unless $0 == 'irb'
    end
    
    private # PRIVATE class methods
    
    def url(type, what=nil, page=1)
      url_base = "#{API_URL}/#{type}"
      url_path = case type
      when :loans
        case what
        when :newest
          "newest.json?page=#{page}"
        when :all
          "search.json?sort_by=newest&page=#{page}"
        when :fundraising, :funded, :in_repayment, :paid, :defaulted
          "search.json?status=#{what}&sort_by=newest&page=#{page}"
        else # lenders
          "#{what}/lenders.json&page=#{page}"
        end

      end
      url = "#{url_base}/#{url_path}"
      url.index('?') ? "#{url}&app_id=com.kivaworld" : "#{url}?app_id=com.kivaworld"
    end
  end # Kiva (self)
end # Kiva

unless $0 == 'irb' # test mode
  Kiva.regenerate!(:kiva_map)
  # Kiva.regenerate!(:kiva_people, true)
  # Kiva.fetch(:lenders)
end