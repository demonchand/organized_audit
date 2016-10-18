require 'rails/observers/active_model/active_model'
require 'active_record'
require "organized_audit/version"
require "organized_audit/model_config"

module OrganizedAudit
	VERSION = "0.0.1"

  def self.get_audits
  	puts "inside the Get audits method"
  	audits = Audited::Audit.all
  	puts "After trigger the function Audits"
  	p audits
  end

  def new_list
  	puts "new list called"
  end
end

::ActiveRecord::Base.send :include, OrganizedAudit::ModelConfig