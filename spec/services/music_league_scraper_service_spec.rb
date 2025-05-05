# spec/services/music_league_scraper_service_spec.rb
require 'rails_helper'

RSpec.describe MusicLeagueScraperService do
  describe '#call' do
    let(:html) { File.read(Rails.root.join("spec/fixtures/files/music_league_sample.html")) }
    let(:scraper) { described_class.new(url: "http://example.com/fake") }

    before do
      stub_request(:get, "http://example.com/fake").to_return(status: 200, body: html)
    end

    it 'extracts Spotify playlist URLs from the page' do
      result = scraper.call

      expect(result).to all(include("open.spotify.com/playlist"))
      expect(result).to include("https://open.spotify.com/playlist/12345")
      expect(result.size).to be > 0
    end
  end
end
