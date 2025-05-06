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

  def import_songs
    playlist = Playlist.find(params[:id])
    @songs = PlaylistSongImporter.new(playlist).call

    @songs.each do |song_attrs|
      playlist.songs.find_or_create_by!(spotify_id: song_attrs[:spotify_id])
    end
  end
end