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
FactoryBot.define do
  factory :song do
    title { "MyString" }
    artist { "MyString" }
    album { "MyString" }
    playlist { nil }
  end
end
