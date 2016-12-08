class Card < ActiveRecord::Base
  unloadable
  include Rails.application.routes.url_helpers

  enum card_type: [ :version, :issue ]
  validates :trello_id, uniqueness: true

  before_validation :post_trello, :on => :create

  belongs_to :version, foreign_key: :redmine_id

  def push!
    TrelloRedmineAux.put!("cards/#{trello_id}", mount_data)
  end

  def pull_from_json!(json)
    update_data(json)
  end

  protected

    def post_trello
      if new_record?
        if version?
          data = mount_data.merge(idList: TrelloRedmineAux.get_setting('version_list_id'))
          card = TrelloRedmineAux.post!('cards', data)
          self.trello_id = card['id']

          add_webhook
        end
      end
    end

    def mount_data
      if version?
        mount_data_from_version
      end
    end

    def mount_data_from_version
      {
        name: "#{version.name} - #{version.project.name}",
        due: version.effective_date.nil? ? nil : version.effective_date.strftime('%F %T'),
        desc: version_url(version, host: TrelloRedmineAux.get_setting('redmine_host'))
      }
    end

    def add_webhook
      webhook = TrelloRedmineAux.post!('webhooks', {
        idModel: self.trello_id,
        callbackURL: trello_webhook_url
      })
    end

    def update_data(json)
      if version?
        update_data_of_version(json)
      end
    end

    def update_data_of_version(json)
      matches = json['name'].match(/(.+) \- .+/)
      version.name = matches[1] unless matches.nil?

      version.effective_date = json['due'].nil? ? nil : DateTime.parse(json['due'])

      version.disable_push!
      version.save
    end
end
