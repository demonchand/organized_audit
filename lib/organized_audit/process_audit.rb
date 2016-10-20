require "organized_audit/filtering"
require "organized_audit/json_constructor"
require "organized_audit/locale_accessor"

module OrganizedAudit
  module ProcessAudit
    include OrganizedAudit::Filtering
    include OrganizedAudit::JsonConstructor
    include OrganizedAudit::LocaleAccessor

    def get_processed_audits
      # TODO: Ransack yet to implement
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
