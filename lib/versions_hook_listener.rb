class VersionsHookListener < Redmine::Hook::ViewListener

  render_on(:view_versions_show_contextual, partial: 'trello_redmine_workflow/version_push_menu')

end
