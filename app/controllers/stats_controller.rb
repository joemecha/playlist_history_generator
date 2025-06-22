class StatsController < ApplicationController
  def index
    @total_songs = Song.count
    @total_artists = Song.select(:artist).distinct.count
    @total_albums = Song.select(:album).distinct.count
    @songs_on_multiple_playlists = Song.joins(:playlist_songs)
                                       .group("songs.id")
                                       .having("COUNT(playlist_songs.id) > 1")
                                       .count
                                       .count

    repeated = Song.joins(:playlist_songs)
                   .group("songs.id")
                   .having("COUNT(playlist_songs.id) > 1")
                   .order("COUNT(playlist_songs.id) DESC, songs.artist ASC")
                   .count
    song_ids = repeated.keys
    @repeated_songs = Song.find(song_ids).index_by(&:id).slice(*song_ids).values
    puts @repeated_songs.class
    puts @repeated_songs.first.inspect
    @repeated_counts = repeated
    @most_frequent_artists = Song.group(:artist)
                                 .having("COUNT(*) > 2")
                                 .order(Arel.sql("COUNT(*) DESC, artist asc"))
                                 .count

    respond_to do |format|
      format.html
      format.csv { send_data generate_stats_csv, filename: "#{Date.today}-ml-stats.csv"}
    end
  end

  require 'csv'

  def generate_stats_csv
    CSV.generate(headers: true) do |csv|
      csv << ["Repeated Songs"]
      csv << ["Title", "Artist", "Playlist Count"]

      @repeated_songs.each do |song|
        count = @repeated_counts[song.id]
        csv << [song.title, song.artist, count]
      end

      csv << []
      csv << ["Top Artists"]
      csv << ["Artist", "Song Count"]

      @most_frequent_artists.each do |artist, count|
        csv << [artist, count]
      end
    end
  end
end
