require 'omf-sfa/models/component'
require 'omf-sfa/models/ip'
require 'omf-sfa/models/link'

module OMF::SFA::Model
  class Interface < Component

    many_to_one :node
    one_to_many :ips
    many_to_one :link

    plugin :nested_attributes
    nested_attributes :node, :ips, :link

    sfa_class 'interface', :can_be_referred => true, :expose_id => false

    sfa :component_manager_id, :disabled => true
    sfa :role, :attribute => true
    sfa :ip, :inline => true
    alias_method :ip, :ips

    def self.exclude_from_json
      sup = super
      [:node_id, :link_id].concat(sup)
    end

    def self.include_nested_attributes_to_json
      sup = super
      [:ips, :link].concat(sup)
    end
  end
end
