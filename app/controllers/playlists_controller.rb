class PlaylistsController < ApplicationController
  def index
    @playlists = Playlist.all
  end

  def scrape
    urls_with_rounds = MusicLeagueScraperService.new.call

    urls_with_rounds.each do |playlist_data|
      Playlist.find_or_create_by(spotify_url: playlist_data[:url], round_number: playlist_data[:round_number], name: playlist_data[:name])
    end

    redirect_to playlists_path, notice: "Playlists fetched and updated."
  end
end