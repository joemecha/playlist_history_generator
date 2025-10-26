# == Schema Information
#
# Table name: playlist_songs
#
#  id          :bigint           not null, primary key
#  playlist_id :bigint           not null
#  song_id     :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song
end
