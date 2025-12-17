# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  album      :string
#  artist     :string
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_songs_on_title_and_artist  (title,artist) UNIQUE
#
class Song < ApplicationRecord
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs

  def playlist_songs_by_league
    playlist_songs.group_by { |ps| ps.playlist.league }
  end
end
