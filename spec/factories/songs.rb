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
FactoryBot.define do
  factory :song do
    title { "MyString" }
    artist { "MyString" }
    album { "MyString" }
  end
end
