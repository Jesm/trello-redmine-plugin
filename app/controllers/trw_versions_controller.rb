class TrwVersionsController < ApplicationController
  unloadable

  def push_to_trello
    version = Version.find(params[:version_id])

    scope = version_card_scope(version)
    if scope.any?
      scope.first.push!
    else
      scope.create!
    end

    redirect_to controller: :versions, action: :show, id: version.id
  end

  protected

    def version_card_scope(version)
      Card.version.where(redmine_id: version.id)
    end

end
