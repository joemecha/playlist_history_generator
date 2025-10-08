class PlaylistsController < ApplicationController
  before_action :set_league, only: [:scrape]

  def index
    @playlists = Playlist.all
                         .includes(:league)
                         .joins(:league)
                         .order('leagues.created_at DESC, playlists.round_number DESC')
  end

  def scrape
    urls_with_rounds = MusicLeagueScraperService.new.call

    urls_with_rounds.each do |playlist_data|
      Playlist.find_or_create_by(
        spotify_url: playlist_data[:url],
        round_number: playlist_data[:round_number],
        name: playlist_data[:name],
        league: @league
      )
    end

    redirect_to playlists_path, notice: "Playlists fetched and updated for league #{@league.name}."
  end

  def import_songs
    playlist = Playlist.find(params[:id])
    @songs = PlaylistSongImporter.new(playlist).call

    @songs.each do |song_attrs|
      playlist.songs.find_or_create_by!(spotify_id: song_attrs[:spotify_id])
    end
  end

  private

  def set_league
    @league = League.last
    # TODO: when routes have been updated to nest playlists under league change the line above to
    # @league = League.find_by(params[:league_id])
  end
end