class SongsController < ApplicationController
  def index
    @songs = Song.includes(playlist_songs: { playlist: :league })
                 .order(:artist, :title)
    @total_songs = @songs.count
    @total_artists = @songs.select(:artist).distinct.count
    @songs_on_multiple_playlists = @songs.select { |song| song.playlist_songs.size > 1 }.count

    max_count = @songs.map { |song| song.playlist_songs.size }.max
    @most_frequent_songs = @songs.select { |song| song.playlist_songs.size == max_count }
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
