require 'rubygems'
require 'fileutils'

module Kiva
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
        when :kiva_map, :kiva_people
          File.join(ROOT, "#{type}", 'public')
        end
      end
    end # Core (self)
  end # Core
end # Kiva

require File.join(Kiva::Core.path(:core), 'fetcher')
require File.join(Kiva::Core.path(:core), 'templater')
require File.join(Kiva::Core.path(:models), 'init')

module Kiva
  API_URL = 'http://api.kivaws.org/v1'
  
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
      when :lenders
        # updates loans
        query = Kiva::Fetcher.load(url(:loans, :all))
        loans = query[type_to_s]
        pages = query['paging']['pages']
        2.upto(pages) do |page|
          query = Kiva::Fetcher.load(url(:loans, :all, page))
          loans += query[type_to_s]
        end
        loans = Kiva::Loan.update_loans!(loans)

        # update lenders
        loans.each do |loan|
          query = Kiva::Fetcher.load(url(:loans, loan.id))
          lenders = query[type_to_s]
          pages = query['paging']['pages']
          2.upto(pages) do |page|
            query = Kiva::Fetcher.load(url(:loans, loan.id, page))
            lenders += query[type_to_s]
          end

          Kiva::Lender.update_lenders!(lenders, loan.id)
        end

      end
    end

    # Regenerates files
    def regenerate!(type, all=false)
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
      puts "An error occour when regeneriting #{type}: #{e}"
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
      "#{url_base}/#{url_path}"
    end
  end # Kiva (self)
end # Kiva

unless $0 == 'irb' # test mode
  Kiva.regenerate!(:kiva_map)
  Kiva.regenerate!(:kiva_people)
end