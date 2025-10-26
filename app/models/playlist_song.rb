# == Schema Information
#
# Table name: playlist_songs
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :bigint           not null
#  song_id     :bigint           not null
#
# Indexes
#
#  index_playlist_songs_on_playlist_id              (playlist_id)
#  index_playlist_songs_on_playlist_id_and_song_id  (playlist_id,song_id) UNIQUE
#  index_playlist_songs_on_song_id                  (song_id)
#
# Foreign Keys
#
#  fk_rails_...  (playlist_id => playlists.id)
#  fk_rails_...  (song_id => songs.id)
#
class PlaylistSong < ApplicationRecord
  belongs_to :playlist
  belongs_to :song
end
