# == Schema Information
#
# Table name: playlists
#
#  id                 :bigint           not null, primary key
#  name               :string
#  round_number       :integer
#  spotify_url        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  spotify_created_at :datetime
#  league_id          :bigint           not null
#
class Playlist < ApplicationRecord
  belongs_to :league
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
end
