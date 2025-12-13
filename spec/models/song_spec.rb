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
require 'rails_helper'

RSpec.describe Song, type: :model do
  # Currently no methods to test
end
