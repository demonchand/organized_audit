# require 'active_support/concern'

module OrganizedAudit
  module ModelConfig
    extend ActiveSupport::Concern

    module ClassMethods
      def customize_audits(master_fields, rules=[], locale_option = :default_locale)
        puts "Inside the Customeze Audits and its Initialized Yeah..."
        class_attribute :audit_options, instance_writer: false

        self.audit_options = { master_fields: master_fields, rules: rules, locale_option: locale_option }

        include OrganizedAudit::ModelConfig::OrganizedAuditInstanceMethods
      end
      # extend Audited::Auditor::AuditedClassMethods
    end

    module OrganizedAuditInstanceMethods
      def get_history
        puts audit_options
        # self.audits
      end

      private

      def construct_query
      end
    end
  end
end
