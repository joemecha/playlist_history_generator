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
FactoryBot.define do
  factory :playlist do
    name { "MyString" }
    spotify_url { "MyString" }
  end
end
