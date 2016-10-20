require "organized_audit/process_audit"

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

      def get_history(options={})
        # TODO: Yet to start
        puts "History log triggered."
      end
    end

    module OrganizedAuditInstanceMethods
      include OrganizedAudit::ProcessAudit

      def get_history(options={})
        puts audit_options
        get_processed_audits
      end
    end
  end
end
