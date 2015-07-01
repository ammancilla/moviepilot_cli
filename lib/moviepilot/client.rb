# 
# Wrapper for the Moviepilot API
# 

require 'json'
require 'rest-client'

module Moviepilot
  class Client

    class << self
      
      # Public: retrieve top posts
      # 
      # api_host - the String url for the host of the API
      # api_version - the String version to use of the API
      # 
      # Returns a Hash of posts
      def trending(opts = {})
        uri = url_for('trending', opts)
        response = RestClient.get(uri)
        JSON.parse response
      end

      # Public: search content that matches the given query
      # 
      # query - String with the word(s) to search by
      # page - the Integer search results page to retrieve
      # api_host - String url of the host of the API
      # api_version - the String version to use of the API
      # 
      # Returns a Hash with the search results
      def search(query, opts = {})
        page = opts[:page] || 1
        uri = url_for('search', opts)
        response = RestClient.get(uri, params: { q: query, page: page })
        JSON.parse response
      end

      # Public: retrieve the information of a post
      # 
      # id - the Integer id of the post to retrieve
      # api_host - String url of the host of the API
      # api_version - the String version to use of the API
      # 
      # Returns a Hash with a post
      def post(id, opts = {})
        uri = url_for("posts/#{id}", opts)
        response = RestClient.get(uri)
        JSON.parse response
      end


      # Public: structure the URL for an endpoint of the API without the query string parameters
      # 
      # path - the String with the relative path to an endpoint of the API
      # api_host - String url of the host of the API
      # api_version - the String version to use of the API
      # 
      # Returns a String with the URL to an endpoint of the API
      def url_for(path, opts = {})
        api_host = opts[:api_host] || Moviepilot.config.api_host
        version = opts[:api_version] || Moviepilot.config.api_version
        [api_host, version, path].join('/')
      end
    end
  end
end