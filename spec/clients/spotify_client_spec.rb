# frozen_string_literal: true

require "rails_helper"

RSpec.describe SpotifyClient do
  let(:client_id) { "client-id" }
  let(:client_secret) { "client-secret" }
  let(:access_token) { "access-token" }

  before do
    stub_const("ENV", ENV.to_h.merge(
      "SPOTIFY_CLIENT_ID" => client_id,
      "SPOTIFY_CLIENT_SECRET" => client_secret
    ))
  end

  describe "#initialize" do
    it "fetches an access token and sets up an authorized connection" do
      token_response = instance_double(
        Faraday::Response,
        success?: true,
        body: { "access_token" => access_token }
      )

      token_conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new)
        .with(url: SpotifyClient::AUTH_URL)
        .and_return(token_conn)

      allow(token_conn).to receive(:post).and_return(token_response)

      api_conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new)
        .with(url: SpotifyClient::BASE_URL)
        .and_return(api_conn)

      allow(api_conn).to receive(:get)

      expect { described_class.new }.not_to raise_error
    end
  end

  describe "#fetch_playlist_tracks" do
    subject(:client) { described_class.new }

    let(:playlist_id) { "playlist123" }
    let(:api_response_body) { { "tracks" => { "items" => [] } } }

    before do
      token_response = instance_double(
        Faraday::Response,
        success?: true,
        body: { "access_token" => access_token }
      )

      token_conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new)
        .with(url: SpotifyClient::AUTH_URL)
        .and_return(token_conn)

      allow(token_conn).to receive(:post).and_return(token_response)
    end

    context "when the API request succeeds" do
      before do
        api_response = instance_double(
          Faraday::Response,
          success?: true,
          body: api_response_body
        )

        api_conn = instance_double(Faraday::Connection)
        allow(Faraday).to receive(:new)
          .with(url: SpotifyClient::BASE_URL)
          .and_return(api_conn)

        allow(api_conn)
          .to receive(:get)
          .with("playlists/#{playlist_id}")
          .and_return(api_response)
      end

      it "returns the response body" do
        result = client.fetch_playlist_tracks(playlist_id)
        expect(result).to eq(api_response_body)
      end
    end

    context "when the API request fails" do
      before do
        api_response = instance_double(
          Faraday::Response,
          success?: false,
          status: 401,
          body: { "error" => "Unauthorized" }
        )

        api_conn = instance_double(Faraday::Connection)
        allow(Faraday).to receive(:new)
          .with(url: SpotifyClient::BASE_URL)
          .and_return(api_conn)

        allow(api_conn)
          .to receive(:get)
          .and_return(api_response)
      end

      it "raises a descriptive error" do
        expect {
          client.fetch_playlist_tracks(playlist_id)
        }.to raise_error(
          RuntimeError,
          /Spotify API error: 401/
        )
      end
    end
  end

  describe "access token fetching failures" do
    it "raises when token fetch fails" do
      token_response = instance_double(
        Faraday::Response,
        success?: false,
        status: 400,
        body: { "error" => "invalid_client" }
      )

      token_conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new)
        .with(url: SpotifyClient::AUTH_URL)
        .and_return(token_conn)

      allow(token_conn).to receive(:post).and_return(token_response)

      expect {
        described_class.new
      }.to raise_error(
        RuntimeError,
        /Token fetch failed: 400/
      )
    end
  end
end
