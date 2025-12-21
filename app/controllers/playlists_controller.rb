class PlaylistsController < ApplicationController
  before_action :set_league, only: [:scrape]

  def index
    @playlists = Playlist.all
                         .includes(:league)
                         .joins(:league)
                         .order('leagues.created_at DESC, playlists.round_number DESC')
  end

  def update_spotify_created_at
    playlist = Playlist.find(params[:id])

    playlist_id = playlist.spotify_url.match(/playlist\/([^?]+)/)[1]
    tracks_data = SpotifyClient.new.fetch_playlist_tracks(playlist_id)
    all_tracks = tracks_data.flat_map { |t| t[:tracks] || [] } rescue []
    first_added_at = all_tracks.min_by { |t| t[:added_at] }&.[](:added_at)

    if first_added_at.present?
      playlist.update(spotify_created_at: first_added_at)
      redirect_to playlists_path, notice: "Spotify created_at updated for #{playlist.name}"
    else
      redirect_to playlists_path, alert: "Could not determine created_at for #{playlist.name}"
    end
  end

  def scrape
    authorize Playlist, :scrape?

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
    imported_tracks = PlaylistSongImporter.new.call(playlist)
    
    imported_tracks.each do |track_attrs|
      song = Song.find_or_create_by!(title: track_attrs[:title], artist: track_attrs[:artist]) do |s|
        s.album = track_attrs[:album_name] if track_attrs[:album_name]
      end
      
      PlaylistSong.find_or_create_by!(playlist: playlist, song: song)
    end

    redirect_to playlists_path, notice: "Songs imported successfully."
  end

  private

  def set_league
    @league = League.last # Set to current league
  end
end