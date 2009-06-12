require 'open-uri'
require 'json'

module Kiva
  module Fetcher
    class << self
      def load(url)
        puts " Fetching #{url}..." if Kiva::Core::DEBUG
        data = URI.parse(url).read
        JSON.parse(data)
      rescue OpenURI::HTTPError => e
        puts "ERROR: #{e}"
        exit(1) unless $0 == 'irb'
      end
      
      def load_all(type, url, page_size, pages)
        data = []
        resources = []
        1.upto(pages) do |page|
          puts " Looking for #{type}'s page #{page} of #{pages}..." if Kiva::Core::DEBUG
          query = load("#{url}&page=#{page}")
          new_data = query[type.to_s]
          resources += yield(new_data) if block_given?
          data += new_data
        end
        return data, resources
      end
    end # Fetcher (self)
  end # Fetcher
end # Kiva