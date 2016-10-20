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
      def get_history(options={})
        puts audit_options
        # Ransack yet to implement
        # entry_entity_audits = self.audits.order("created_at desc")

        rule_entities = {}
        rule_entities[self.class.name.downcase.to_sym] = self.audits.order("created_at desc")

        audit_options[:rules].map { |rule| rule[:entity] }.each do |entity|
          relation_ids = get_rule_base_relation_ids(entity)
          options = { class_name: entity.to_s.singularize.camelize.constantize,
                      ids: relation_ids
          }
          query = construct_query(options)
          rule_entities[entity] = Audited::Audit.where("#{query}")
        end
        rule_entities
      end

      private

      def get_filetered_rules
        self.class.reflect_on_all_associations.map(&:name).reject { |x| x == :audits }
      end

      def get_relationship_name(entity)
        relation_name = if get_filetered_rules.include? entity.singularize.to_sym
          entity.singularize
        elsif get_filetered_rules.include? entity.pluralize.to_sym
          entity.pluralize
        else
          nil
        end
        return relation_name
      end

      def get_rule_base_relation_ids(entity)
        return [] if get_relationship_name(entity.to_s).nil?

        relation_name = get_relationship_name(entity.to_s)
        self.public_send(relation_name).map(&:id)
      end

      def construct_query(options={})
        query = ""
        query += "auditable_type='#{options[:class_name]}' " if options[:class_name].present?
        query += "and auditable_id in (#{options[:ids].join(',')})" if options[:ids].present?
        query
      end
    end
  end
end
