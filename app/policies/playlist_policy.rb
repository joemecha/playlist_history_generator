class PlaylistPolicy < ApplicationPolicy
  def scrape?
    user.admin?
  end

  def update?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
