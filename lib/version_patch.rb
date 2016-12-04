# Source: http://www.redmine.org/projects/redmine/wiki/Plugin_Internals

require_dependency 'version'

module VersionPatch
  def self.included(base)
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable

      has_one :card, -> { version }, foreign_key: :redmine_id
      after_update :push_to_trello
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    protected

      def push_to_trello
        card.push! if project.module_enabled?('trello_redmine_workflow') && !card.nil?
      end

  end
end

Version.send(:include, VersionPatch)
