# == Schema Information
#
# Table name: leagues
#
#  id              :bigint           not null, primary key
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  music_league_id :string
#  url             :string
#
class League < ApplicationRecord
  has_many :playlists, dependent: :destroy
end
