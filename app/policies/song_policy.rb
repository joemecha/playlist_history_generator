class SongPolicy < ApplicationPolicy
  def import?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
