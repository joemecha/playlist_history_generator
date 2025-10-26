# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  title      :string
#  artist     :string
#  album      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Song < ApplicationRecord
  has_many :playlist_songs, dependent: :destroy
  has_many :playlists, through: :playlist_songs
end
