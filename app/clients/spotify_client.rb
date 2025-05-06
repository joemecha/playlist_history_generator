require 'faraday'
require 'base64'

class SpotifyClient
  BASE_URL = 'https://api.spotify.com/v1'
  AUTH_URL = 'https://accounts.spotify.com/api/token'

  def initialize
    @access_token = fetch_access_token
    @conn = Faraday.new(url: BASE_URL) do |f|
      f.request :authorization, 'Bearer', @access_token
      f.response :json, content_type: /\bjson$/
    end
  end

  def fetch_playlist_tracks(playlist_id)
    response = @conn.get("playlists/#{playlist_id}")
    if response.success?
      response.body
    else
      raise "Spotify API error: #{response.status} - #{response.body}"
    end
  end

  private

  def fetch_access_token
    conn = Faraday.new(url: AUTH_URL) do |f|
      f.request :url_encoded
      f.response :json
    end

    credentials = Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")

    response = conn.post do |req|
      req.headers['Authorization'] = "Basic #{credentials}"
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = { grant_type: 'client_credentials' }
    end

    if response.success?
      response.body['access_token']
    else
      raise "Token fetch failed: #{response.status} - #{response.body}"
    end
  end
end
