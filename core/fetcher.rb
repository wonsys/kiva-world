require 'open-uri'
require 'json'

module Kiva
  module Fetcher
    class << self
      def load(url)
        puts "Fetching #{url}..." if Kiva::Core::DEBUG
        data = URI.parse(url).read
        JSON.parse(data)
      rescue OpenURI::HTTPError => e
        puts "ERROR: #{e}"
        exit(1) unless $0 == 'irb'
      end
      
      def load_all(type, url, page_size, pages)
        data = []
        1.upto(pages) do |page|
          query = load("#{url}&page=#{page}")
          data += query[type.to_s]
        end
        data
      end
    end # Fetcher (self)
  end # Fetcher
end # Kiva