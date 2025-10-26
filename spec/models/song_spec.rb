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
require 'rails_helper'

RSpec.describe Song, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
