require 'dm-core'
require 'dm-timestamps'
require 'dm-types'

path = File.expand_path(File.dirname(__FILE__))

DataMapper.setup(:default, {
  :adapter  => 'mysql',
  :database => 'kiva_world',
  :username => 'root', # kiva
  :password => '', # to change!!
  :host     => 'localhost'
})

module Kiva
  class Resource
    class << self

      # If force is true forces fetching of all objects (creates the new ones and tries to updates the old ones)
      def update_all!(force=false)
        Kiva::Partner.update_all!(force)
        Kiva::Loan.update_all!(force)
        Kiva::Lender.update_all!(force)
      end
      
      protected # PROTECTED class methods
      
      def update_resource(type, url, id, force, except=[], url_id=nil)
        klass = Kiva.const_get(type.to_s.singularize.capitalize)
        
        url_info = Kiva::Core.url_info(url, url_id)
        fetched_resources =  url_info[:data] ? url_info[:data][type] : Kiva::Fetcher.load_all(type, url_info[:url], url_info[:page_size], url_info[:pages])
        raise "WRONG DATA: declared ##{url_info[:size]}, fetched ##{fetched_resources.size}" unless fetched_resources.size == url_info[:size]
        
        resources = []
        fetched_resources.each do |resource|
          excepted_fields = []
          except.each { |e| excepted_fields += resource.delete(e) } if except.any?
          excepted_fields.uniq!
          
          if(r = klass.get(resource[id]))
            r.attributes = resource if force
          else
            r = klass.new(resource)
          end
          
          if r && r.dirty?
            yield(r, excepted_fields) if block_given?
            raise "ERROR when saving a #{klass} ##{loan['id']}" unless r.save
            resources << r
          end
        end
        resources
      end
    end # Resource (self)
  end # Resource
end # Kiva

require File.join(path, 'loan')
require File.join(path, 'borrower')
require File.join(path, 'lender')
require File.join(path, 'partner')
require File.join(path, 'country')