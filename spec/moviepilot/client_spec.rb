require 'spec_helper'

describe Moviepilot::Client do
  
  describe '.trending' do
    it 'retrieve the top ten posts' do
      top = Moviepilot::Client.trending

      expect(top['collection']).to be_truthy
      expect(top['collection'].length).to eq(10)
    end
  end

  describe '.search' do
    it 'search for the content that matches the given query' do
      results = Moviepilot::Client.search('marvel', page: 5, api_version: 'v3')

      expect(results['search']).to be_truthy
      expect(results['current_page']).to eq(5)
    end 
  end

  describe '.posts' do
    it 'retrieve a post by ID' do
      post = Moviepilot::Client.post(3347745)

      expect(post['id']).to eq(3347745)
    end
  end

  describe '.url_for' do
    it 'generate the URL to an endpoint of the API' do
      url = Moviepilot::Client.url_for('search', api_version: 'v3')
      expect(url).to eq('api.moviepilot.com/v3/search')
    end
  end
end