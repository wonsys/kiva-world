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
        begin
          Kiva::Partner.update_all!(force)
          Kiva::Loan.update_all!(force)
          Kiva::Lender.update_all!(force)
        rescue => e
          puts "WARNING: error..#{e}" if Kiva::Core::DEBUG
          false
        end  
      end
      
      private # PRIVATE class methods
      
      def update_resources(type, url, id, force, except=[], url_id=nil, &block)
        klass = Kiva.const_get(type.to_s.singularize.capitalize)
        
        url_info = Kiva::Core.url_info(url, url_id)
        if url_info
          if url_info[:data] # data ready now (only 1 page)
            fetched_resources = url_info[:data][type.to_s]
            resources = add_resources(fetched_resources, klass, id, force, except, &block)
          else
            fetched_resources, resources = Kiva::Fetcher.load_all(type, url_info[:url], url_info[:page_size], url_info[:pages]) {|resources| add_resources(resources, klass, id, force, except, &block)}
          end
          puts "WARNING: wrong data..declared ##{url_info[:size]}, fetched ##{fetched_resources.size}" if Kiva::Core::DEBUG && fetched_resources.size != url_info[:size]
          resources
        else
          nil
        end
      end
      
      def add_resources(resources, klass, id, force, except, &block)
        new_resources = []
        resources.each do |resource|
          excepted_fields = {}
          except.each { |e| excepted_fields[e] = resource.delete(e) } if except.any?
          
          if(r = klass.get(resource[id]))
            r.attributes = resource if force
          else
            r = klass.new(resource)
          end

          if r && r.dirty?
            # yield(r, excepted_fields) if block_given?
            excepted_fields.each do |field, data|
              if data.any?
                data.uniq!
                method = field.to_sym
                field_resources = r.send(method)
                field_resources.destroy! if field_resources.any?
                data.each {|e| r.send(method) << r.send(method).build(e) }
              end
            end if excepted_fields.any?
            
            raise "ERROR when saving a #{klass} ##{loan['id']}" unless r.save
            new_resources << r
          end
        end
        new_resources
      end
    end # Resource (self)
  end # Resource
end # Kiva

require File.join(path, 'loan')
require File.join(path, 'borrower')
require File.join(path, 'lender')
require File.join(path, 'partner')
require File.join(path, 'country')
require File.join(path, 'payment')
require File.join(path, 'description')