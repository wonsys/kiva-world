require 'open-uri'
require 'json/pure'

module Kiva
  module Fetcher
    class << self
      def load(url)
        puts "Fetching #{url}..."
        data = URI.parse(url).read
        JSON.parse(data)
      rescue OpenURI::HTTPError => e
        puts "ERROR: #{e}"
        exit(1)
      end
    end # Fetcher (self)
  end # Fetcher
end # Kiva