# require 'rails/observers/active_model/active_model'
require 'active_record'
require "organized_audit/version"
require "organized_audit/model_config"

module OrganizedAudit
	VERSION = "0.0.1"
end

::ActiveRecord::Base.send :include, OrganizedAudit::ModelConfig