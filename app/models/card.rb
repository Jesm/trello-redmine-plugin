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

  protected

    def post_trello
      if new_record?
        if version?
          data = mount_data.merge(idList: TrelloRedmineAux.get_setting('version_list_id'))
          card = TrelloRedmineAux.post!('cards', data)
          self.trello_id = card['id']
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
end
