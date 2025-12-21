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
require "rails_helper"

RSpec.describe Song, type: :model do
  describe ".search" do
    let!(:matching_title) do
      create(:song, title: "Midnight City", artist: "M83", album: "Hurry Up")
    end

    let!(:matching_artist) do
      create(:song, title: "Genesis", artist: "Grimes", album: "Visions")
    end

    let!(:matching_album) do
      create(:song, title: "Song 2", artist: "Blur", album: "Parklife")
    end

    let!(:non_matching) do
      create(:song, title: "Hello", artist: "Adele", album: "25")
    end

    context "when query is blank" do
      it "returns all songs" do
        expect(described_class.search(nil))
          .to contain_exactly(
            matching_title,
            matching_artist,
            matching_album,
            non_matching
          )
      end
    end

    context "when query matches title" do
      it "returns matching songs" do
        expect(described_class.search("midnight"))
          .to contain_exactly(matching_title)
      end
    end

    context "when query matches artist" do
      it "returns matching songs" do
        expect(described_class.search("grimes"))
          .to contain_exactly(matching_artist)
      end
    end

    context "when query matches album" do
      it "returns matching songs" do
        expect(described_class.search("park"))
          .to contain_exactly(matching_album)
      end
    end

    context "when query matches nothing" do
      it "returns no records" do
        expect(described_class.search("does-not-exist")).to be_empty
      end
    end
  end

    describe "#playlist_songs_by_league" do
    let(:song) { create(:song) }

    let(:league_one) { create(:league, name: "League One") }
    let(:league_two) { create(:league, name: "League Two") }

    let(:playlist_one) { create(:playlist, league: league_one) }
    let(:playlist_two) { create(:playlist, league: league_one) }
    let(:playlist_three) { create(:playlist, league: league_two) }

    let!(:ps1) { create(:playlist_song, song: song, playlist: playlist_one) }
    let!(:ps2) { create(:playlist_song, song: song, playlist: playlist_two) }
    let!(:ps3) { create(:playlist_song, song: song, playlist: playlist_three) }

    subject(:grouped) { song.playlist_songs_by_league }

    it "groups playlist songs by league" do
      expect(grouped.keys).to contain_exactly(league_one, league_two)
    end

    it "includes all playlist songs for a league" do
      expect(grouped[league_one]).to contain_exactly(ps1, ps2)
      expect(grouped[league_two]).to contain_exactly(ps3)
    end
  end
end
