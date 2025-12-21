# frozen_string_literal: true

require "rails_helper"

RSpec.describe PlaylistSongImporter, type: :service do
  subject(:service) { described_class.new(spotify_client: spotify_client) }

  let(:spotify_client) { instance_double(SpotifyClient) }

  let(:playlist) do
    create(
      :playlist,
      spotify_url: "https://open.spotify.com/playlist/playlist123"
    )
  end

  let(:tracks_payload) do
    {
      "tracks" => {
        "items" => [
          {
            "added_at" => "2023-01-02T00:00:00Z",
            "track" => {
              "id" => "spotify-1",
              "name" => "Song One",
              "preview_url" => "http://preview",
              "artists" => [{ "name" => "Artist One" }],
              "album" => {
                "name" => "Album One",
                "images" => [{ "url" => "http://image" }]
              }
            }
          },
          {
            "added_at" => "2023-01-01T00:00:00Z",
            "track" => {
              "id" => "spotify-2",
              "name" => "Song Two",
              "artists" => [{ "name" => "Artist Two" }],
              "album" => { "name" => "Album Two" }
            }
          }
        ]
      }
    }
  end

  before do
    allow(spotify_client)
      .to receive(:fetch_playlist_tracks)
      .with("playlist123")
      .and_return(tracks_payload)
  end

  describe "#call" do
    it "fetches tracks from Spotify using the playlist ID" do
      service.call(playlist)

      expect(spotify_client)
        .to have_received(:fetch_playlist_tracks)
        .with("playlist123")
    end

    it "creates songs from track data" do
      expect {
        service.call(playlist)
      }.to change(Song, :count).by(2)

      expect(Song).to exist(title: "Song One", artist: "Artist One")
      expect(Song).to exist(title: "Song Two", artist: "Artist Two")
    end

    it "creates playlist-song associations" do
      expect {
        service.call(playlist)
      }.to change(PlaylistSong, :count).by(2)

      expect(playlist.songs.pluck(:title))
        .to match_array(["Song One", "Song Two"])
    end

    it "sets spotify_created_at to the earliest added_at timestamp" do
      service.call(playlist)

      expect(playlist.reload.spotify_created_at)
        .to eq(Time.parse("2023-01-01T00:00:00Z"))
    end

    it "is idempotent for songs and playlist associations" do
      service.call(playlist)

      expect {
        service.call(playlist)
      }.not_to change(Song, :count)

      expect {
        service.call(playlist)
      }.not_to change(PlaylistSong, :count)
    end

    context "when a track has no artist" do
      let(:tracks_payload) do
        {
          "tracks" => {
            "items" => [
              {
                "added_at" => "2023-01-01T00:00:00Z",
                "track" => {
                  "id" => "spotify-x",
                  "name" => "Nameless Song",
                  "artists" => []
                }
              }
            ]
          }
        }
      end

      it "uses 'Unknown Artist' as a fallback" do
        service.call(playlist)

        expect(Song)
          .to exist(title: "Nameless Song", artist: "Unknown Artist")
      end
    end
  end

  describe ".import_all" do
    let!(:playlist_one) { create(:playlist, spotify_url: "https://open.spotify.com/playlist/one") }
    let!(:playlist_two) { create(:playlist, spotify_url: "https://open.spotify.com/playlist/two") }

    before do
      allow(spotify_client).to receive(:fetch_playlist_tracks).and_return(tracks_payload)
      allow(SpotifyClient).to receive(:new).and_return(spotify_client)
    end

    it "imports songs for all playlists" do
      expect {
        described_class.call
      }.to change(PlaylistSong, :count).by(4)
    end
  end
end
