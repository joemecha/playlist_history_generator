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
require 'rails_helper'

RSpec.describe Playlist, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
