# require 'active_support/concern'

module OrganizedAudit
  module ModelConfig
    extend ActiveSupport::Concern

    module ClassMethods
      def customize_audits(options = {})
        puts "Inside the Customeze Audits and its Initialized Yeah..."
        class_attribute :audit_options, instance_writer: false

        self.audit_options = options

        include OrganizedAudit::ModelConfig::OrganizedAuditInstanceMethods
      end
      # extend Audited::Auditor::AuditedClassMethods
    end

    module OrganizedAuditInstanceMethods
      def get_history
        self.audits
      end

      private

      def construct_query
      end
    end
  end
end
