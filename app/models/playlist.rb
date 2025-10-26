# == Schema Information
#
# Table name: playlists
#
#  id                 :bigint           not null, primary key
#  name               :string
#  round_number       :integer
#  spotify_created_at :datetime
#  spotify_url        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  league_id          :bigint           not null
#
# Indexes
#
#  index_playlists_on_league_id  (league_id)
#
# Foreign Keys
#
#  fk_rails_...  (league_id => leagues.id)
#
class Playlist < ApplicationRecord
  belongs_to :league
  has_many :playlist_songs, dependent: :destroy
  has_many :songs, through: :playlist_songs
end
