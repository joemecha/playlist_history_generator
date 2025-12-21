require "rails_helper"

RSpec.describe ApplicationPolicy do
  let(:user)   { instance_double("User") }
  let(:record) { instance_double("Record") }

  subject(:policy) { described_class.new(user, record) }

  describe "default permissions" do
    it "denies index" do
      expect(policy.index?).to be(false)
    end

    it "denies show" do
      expect(policy.show?).to be(false)
    end

    it "denies create" do
      expect(policy.create?).to be(false)
    end

    it "denies update" do
      expect(policy.update?).to be(false)
    end

    it "denies destroy" do
      expect(policy.destroy?).to be(false)
    end
  end

  describe "delegated permissions" do
    it "delegates new? to create?" do
      expect(policy.new?).to eq(policy.create?)
    end

    it "delegates edit? to update?" do
      expect(policy.edit?).to eq(policy.update?)
    end
  end
end

RSpec.describe ApplicationPolicy::Scope do
  let(:user)  { instance_double("User") }
  let(:scope) { class_double("ActiveRecord::Relation") }

  subject(:policy_scope) { described_class.new(user, scope) }

  describe "#resolve" do
    it "raises an error forcing subclasses to implement resolve" do
      expect { policy_scope.resolve }
        .to raise_error(NoMethodError, /define #resolve/)
    end
  end
end
