require "rails_helper"

RSpec.describe "Playlists", type: :request do
  let(:user) { create(:user, admin: true) }

  before do
    sign_in user
  end

  describe "GET /playlists" do
    let!(:older_league) { create(:league, created_at: 2.days.ago) }
    let!(:newer_league) { create(:league, created_at: 1.day.ago) }

    let!(:playlist_old) do
      create(:playlist, league: older_league, round_number: 1)
    end

    let!(:playlist_new) do
      create(:playlist, league: newer_league, round_number: 2)
    end

    it "returns playlists ordered by league created_at desc, then round_number desc" do
      get playlists_path

      expect(response).to have_http_status(:ok)
      body = response.body
      expect(body.index(playlist_new.name)).to be < body.index(playlist_old.name)
    end
  end

  describe "POST /playlists/:id/update_spotify_created_at" do
    let(:playlist) do
      create(
        :playlist,
        spotify_url: "https://open.spotify.com/playlist/abc123",
        name: "Test Playlist"
      )
    end

    let(:spotify_client) { instance_double(SpotifyClient) }

    before do
      allow(SpotifyClient).to receive(:new).and_return(spotify_client)
    end

    context "when spotify tracks contain added_at timestamps" do
      let(:tracks_data) do
        [
          { tracks: [{ added_at: 3.days.ago }, { added_at: 1.day.ago }] }
        ]
      end

      before do
        allow(spotify_client).to receive(:fetch_playlist_tracks)
          .and_return(tracks_data)
      end

      it "updates spotify_created_at and redirects with notice" do
        patch update_spotify_created_at_playlist_path(playlist)

        expect(response).to redirect_to(playlists_path)
        follow_redirect!

        expect(flash[:notice]).to match(/Spotify created_at updated/)
        expect(playlist.reload.spotify_created_at).to be_present
      end
    end

    context "when spotify tracks are empty" do
      before do
        allow(spotify_client).to receive(:fetch_playlist_tracks)
          .and_return([])
      end

      it "does not update spotify_created_at and redirects with alert" do
        patch update_spotify_created_at_playlist_path(playlist)

        expect(response).to redirect_to(playlists_path)
        follow_redirect!

        expect(flash[:alert]).to match(/Could not determine created_at/)
        expect(playlist.reload.spotify_created_at).to be_nil
      end
    end
  end

  describe "POST /playlists/scrape" do
    let!(:league) { create(:league, name: "Test League") }
    let(:scraper_result) do
      [
        {
          url: "https://open.spotify.com/playlist/xyz",
          round_number: 1,
          name: "Round 1 Playlist"
        }
      ]
    end

    before do
      allow(MusicLeagueScraperService)
        .to receive_message_chain(:new, :call)
        .and_return(scraper_result)
    end

    it "creates playlists for the league and redirects" do
      post scrape_playlists_path

      expect(response).to redirect_to(playlists_path)
      follow_redirect!

      expect(flash[:notice]).to match(/Playlists fetched and updated/)
      expect(Playlist.count).to eq(1)
      expect(Playlist.first.league).to eq(league)
    end
  end

  describe "POST /playlists/:id/import_songs" do
    let(:league) { create(:league) }
    let(:playlist) { create(:playlist, league: league) }
    let(:imported_songs) { [{ title: "Song 1", artist: "Artist 1" }] }

    before do
      importer_double = instance_double(PlaylistSongImporter)
      allow(PlaylistSongImporter).to receive(:new).and_return(importer_double)
      allow(importer_double).to receive(:call).with(playlist).and_return(imported_songs)
    end

    it "imports songs into the playlist" do
      post import_songs_playlist_path(playlist)

      expect(response).to redirect_to(playlists_path)
    end
  end
end
