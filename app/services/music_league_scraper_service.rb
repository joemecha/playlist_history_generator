require 'nokogiri'
require 'faraday'

class MusicLeagueScraperService
  MUSIC_LEAGUE_URL = ENV["MUSIC_LEAGUE_LEAGUE_URL"]

  def initialize(url: MUSIC_LEAGUE_URL)
    @url = url
  end

  def call
    # NOTE: will not work without cookie (automate login later)
    response = Faraday.get(@url) do |req|
      req.headers['Cookie'] = ENV["MUSIC_LEAGUE_COOKIE"]
    end

    return [] unless response.success?

    doc = Nokogiri::HTML(response.body)
    extract_playlist_data(doc)
  end

  private

  def extract_playlist_data(doc)
    playlists = []

    doc.css('div.row.mb-3').each do |round_div|
      name = round_div.at_css('h5.card-title')&.text&.strip
      round_number = round_div.at_css('span.card-text.text-body-tertiary')
        &.text&.strip
        &.match(/ROUND\s+(\d+)/i)
        &.captures&.first&.to_i
      url = round_div.at_css('a[href*="open.spotify.com/playlist"]')&.[]('href')
  
      next unless round_number && url
  
      playlists << { name:, round_number:, url: }
    end

    playlists
  end
end
