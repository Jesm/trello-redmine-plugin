class TrelloWebhookController < ApplicationController
  unloadable

  skip_before_filter :check_if_login_required, :verify_authenticity_token

  def webhook
    return head :ok if request.head?

    return handle_webhook_json params['model'] if request.content_type == "application/json"
  end

  protected

    def handle_webhook_json(json)
      card = Card.where(trello_id: json['id']).first!
      card.pull_from_json!(json)

      head :ok
    end

end
