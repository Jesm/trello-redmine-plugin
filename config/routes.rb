# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'versions/:version_id/push', :to => 'trw_versions#push_to_trello', as: :version_push

get 'trello/webhook', :to => 'trello_webhook#webhook', as: :trello_webhook
post 'trello/webhook', :to => 'trello_webhook#webhook'