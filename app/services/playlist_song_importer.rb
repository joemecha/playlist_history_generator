class PlaylistSongImporter
  def initialize(spotify_client: SpotifyClient.new)
    @spotify_client = spotify_client
  end

  def import_all
    playlists = Playlist.all

    playlist_songs = PlaylistSong.where(playlist_id: playlists.pluck(:id)).pluck(:playlist_id)

    playlists.each do |playlist|
      next if playlist_songs.include?(playlist.id)

      playlist_id = _extract_playlist_id(playlist.spotify_url)
      tracks_data = @spotify_client.fetch_playlist_tracks(playlist_id)
      all_tracks = _fetch_all_tracks(tracks_data)

      _create_songs_and_associations(playlist, all_tracks)
    end
  end

  private

  def _extract_playlist_id(spotify_url)
    URI.parse(spotify_url).path.split('/').last
  end

  def _fetch_all_tracks(tracks_data)
    items = tracks_data.dig('tracks', 'items') || []

    items.map do |item|
      track_info = item['track']
      next unless track_info.present?

      {
        title: track_info["name"],
        artist: _extract_primary_artist(track_info),
        spotify_id: track_info["id"],
        album_name: track_info.dig("album", "name"),
        album_art_url: track_info.dig("album", "images", 0, "url"),
        preview_url: track_info["preview_url"],
        added_at: item["added_at"]
      }
    end.compact
  end

  def _extract_primary_artist(track_info)
    artist = track_info["artists"]&.first
    artist ? artist["name"] : "Unknown Artist"
  end

  def _create_songs_and_associations(playlist, tracks)
    tracks.each do |track|
      title = track[:title]
      artist = track[:artist]
      album = track[:album_name]

      next unless title && artist

      song = Song.find_or_create_by(title:, artist:) do |s|
        s.album = album
      end

      PlaylistSong.find_or_create_by(playlist:, song:)
    end
  end
end
