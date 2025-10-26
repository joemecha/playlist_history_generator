# == Schema Information
#
# Table name: leagues
#
#  id              :bigint           not null, primary key
#  name            :string
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  music_league_id :string
#
# Indexes
#
#  index_leagues_on_music_league_id  (music_league_id) UNIQUE
#
class League < ApplicationRecord
  has_many :playlists, dependent: :destroy
end
