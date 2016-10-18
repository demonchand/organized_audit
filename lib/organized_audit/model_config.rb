# require 'active_support/concern'

module OrganizedAudit
  module ModelConfig
    extend ActiveSupport::Concern

    module ClassMethods
	    def customize_audits(options = {})
	    	puts "Inside the Customeze Audits"
	    end
    end
  end
end
