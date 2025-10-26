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
require 'rails_helper'

RSpec.describe League, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
