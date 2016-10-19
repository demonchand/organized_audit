# require 'active_support/concern'

module OrganizedAudit
  module ModelConfig
    extend ActiveSupport::Concern

    module ClassMethods
      def customize_audits(options = {})
        class_attribute :audit_options, instance_writer: false

        self.audit_options = options
        puts "Inside the Customeze Audits"

        include OrganizedAudit::ModelConfig::CustInstanceMethods
      end
      # extend Audited::Auditor::AuditedClassMethods
    end

    module CustInstanceMethods
      def another_method
        puts "Inside the another method"
        puts audit_options
      end
    end
  end
end
