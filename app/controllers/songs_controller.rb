class SongsController < ApplicationController
  def index
    @songs = Song.includes(playlist_songs: { playlist: :league })
                 .order(:artist, :title)
                 .page(params[:page])
                 .per(100)
                 
    # Stats
    @total_songs = Song.count
    @total_artists = Song.distinct.count(:artist)
    @songs_on_multiple_playlists = PlaylistSong.group(:song_id)
                                               .having('COUNT(*) > 1')
                                               .count
                                               .size

    playlist_counts = PlaylistSong.group(:song_id).count
    max_count = playlist_counts.values.max || 0
    most_frequent_song_ids = PlaylistSong.group(:song_id)
                                         .having('COUNT(*) = ?', max_count)
                                        .pluck(:song_id)
    @most_frequent_songs = Song.includes(playlist_songs: { playlist: :league })
                           .where(id: most_frequent_song_ids)
                           .order(:artist, :title)
  end

  def import
    authorize Song, :import?

    PlaylistSongImporter.new.import_all
    redirect_to songs_path, notice: "Songs imported successfully."
  end

  require 'csv'

  def export_csv
    @songs = Song.includes(playlist_songs: :playlist).order(:title)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Title", "Artist", "Album", "Playlists", "Rounds"]

      @songs.each do |song|
        playlists = song.playlist_songs.map(&:playlist).uniq
        playlist_names = playlists.map(&:name).join(", ")
        rounds = playlists.map(&:round_number).compact.join(", ")

        csv << [song.title, song.artist, song.album, playlist_names, rounds]
      end
    end

    send_data csv_data, filename: "#{Date.today}-ml-song-history.csv", type: 'text/csv'
  end
end
