require_dependency 'version_patch'

Redmine::Plugin.register :teste do
  name 'Trello Redmine Workflow'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Redmine::Plugin.register :trello_redmine_workflow do
  project_module :trello_redmine_workflow do
    permission :push_versions, :trw_versions => :push_to_trello, :public => true
  end

  settings :default => {app_key: '', user_token: '', version_board_id: '', redmine_host: '', version_list_id: ''},
  				:partial => 'settings/trello_redmine_workflow_config'
end

require_dependency 'versions_hook_listener'