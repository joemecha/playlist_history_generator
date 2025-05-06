class PlaylistSongImporter
  def initialize(spotify_client: SpotifyClient.new)
    @spotify_client = spotify_client
  end

  def import_all(playlists = Playlist.all)
    playlists.each do |playlist|
      next if playlist.playlist_songs.exists?

      playlist_id = _extract_playlist_id(playlist.spotify_url)
      tracks_data = @spotify_client.fetch_playlist_tracks(playlist_id)
      all_tracks = fetch_all_tracks(tracks_data)
      _create_songs_and_associations(playlist, all_tracks)
    end
  end

  private

  def _extract_playlist_id(spotify_url)
    URI.parse(spotify_url).path.split('/').last
  end

  def fetch_all_tracks(tracks_data)
    items = tracks_data['items']
    next_url = tracks_data['next']

    while next_url
      response = @spotify_client.fetch_url(next_url)
      items.concat(response['items'])
      next_url = response['next']
    end

    items
  end

  def _create_songs_and_associations(playlist, tracks)
    tracks.each do |track|
      track = track['track']
      next unless track

      title = track['name']
      artist = track['artists']&.first&.dig('name')
      album = track['album']&.dig('name')

      next unless title && artist # TODO: should it skip silently?

      song = Song.find_or_create_by(title:, artist:) do |s|
        s.album = album
      end

      PlaylistSong.find_or_create_by(playlist:, song:)
    end
  end
end
