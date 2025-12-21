require "rails_helper"

RSpec.describe PlaylistPolicy do
  let(:playlist) { build_stubbed(:playlist) }

  subject(:policy) { described_class.new(user, playlist) }

  context "when the user is an admin" do
    let(:user) { build_stubbed(:user, admin: true) }

    it "allows scrape" do
      expect(policy.scrape?).to be(true)
    end

    it "allows update" do
      expect(policy.update?).to be(true)
    end
  end

  context "when the user is not an admin" do
    let(:user) { build_stubbed(:user, admin: false) }

    it "denies scrape" do
      expect(policy.scrape?).to be(false)
    end

    it "denies update" do
      expect(policy.update?).to be(false)
    end
  end
end

RSpec.describe PlaylistPolicy::Scope do
  let(:user) { build_stubbed(:user) }
  let(:scope) { Playlist.all }

  subject(:resolved_scope) { described_class.new(user, scope).resolve }

  it "returns all playlists" do
    expect(resolved_scope).to eq(scope)
  end
end
