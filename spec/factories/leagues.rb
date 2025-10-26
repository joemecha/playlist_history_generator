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
FactoryBot.define do
  factory :league do
    name { "MyString" }
    music_league_id { "123abc" }
    url { "www.example.com/music_league"}
  end
end
