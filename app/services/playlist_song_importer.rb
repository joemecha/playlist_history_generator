class PlaylistSongImporter
  def initialize(spotify_client: SpotifyClient.new)
    @spotify_client = spotify_client
  end

  def call(playlist = nil)
    if playlist
      _import_playlist(playlist)
    else
      _import_all_playlists
    end
  end

  def self.call(playlist = nil)
    new.call(playlist)
  end

  private

  attr_reader :spotify_client

  def _import_all_playlists
    Playlist.find_each do |playlist|
      _import_playlist(playlist)
    end
  end

  def _import_playlist(playlist)
    playlist_id = _extract_playlist_id(playlist.spotify_url)
    tracks_data = spotify_client.fetch_playlist_tracks(playlist_id)
    tracks = _fetch_all_tracks(tracks_data)

    playlist.update(
      spotify_created_at: tracks.min_by { |t| t[:added_at] }&.[](:added_at)
    )

    _create_songs_and_associations(playlist, tracks)
  end

  def _extract_playlist_id(spotify_url)
    URI.parse(spotify_url).path.split('/').last
  end

  def _fetch_all_tracks(tracks_data)
    items = tracks_data.dig('tracks', 'items') || []

    items.map do |item|
      track = item['track']
      next unless track.present?

      {
        title: track["name"],
        artist: _extract_primary_artist(track),
        spotify_id: track["id"],
        album_name: track.dig("album", "name"),
        album_art_url: track.dig("album", "images", 0, "url"),
        preview_url: track["preview_url"],
        added_at: item["added_at"]
      }
    end
  end

  def _extract_primary_artist(track)
    track["artists"]&.first&.dig("name") || "Unknown Artist"
  end

  def _create_songs_and_associations(playlist, tracks)
    tracks.each do |track|
      next unless track[:title] && track[:artist]

      song = Song.find_or_create_by(title: track[:title], artist: track[:artist]) do |s|
        s.album = track[:album_name]
      end

      PlaylistSong.find_or_create_by(playlist:, song:)
    end
  end
end
