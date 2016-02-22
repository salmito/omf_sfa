require 'omf-sfa/models/component'
require 'omf-sfa/models/cmc'
require 'omf-sfa/models/sliver_type'

module OMF::SFA::Model
  class Node < Component

    one_to_many :interfaces
    one_to_many :cpus
    one_to_many :usb_devices
    many_to_one :cmc
    many_to_one :location
    many_to_one :sliver_type

    plugin :nested_attributes
    nested_attributes :interfaces, :cpus, :cmc, :location, :sliver_type, :usb_devices

    sfa_class 'node'
    sfa :client_id, :attribute => true
    sfa :hardware_type, :attr_value => 'name'
    sfa :available, :attr_value => 'now'  # <available now="true">
    sfa :sliver_type, :inline => true
    sfa :interfaces, :inline => true, :has_many => true
    sfa :exclusive, :attribute => true
    sfa :location, :inline => true
    sfa :boot_state, :attribute => true
    sfa :monitored, :attribute => true
    sfa :services
    sfa :monitoring

    def services
      return nil if self.account.id == OMF::SFA::Model::Account.where(name: '__default__').first.id
      gateway = self.parent.gateway
      el = "<login authentication=\"ssh-keys\" hostname=\"#{gateway}\" port=\"22\" username=\"#{self.account.name}\"/>"
      Nokogiri::XML(el).child
    end

    attr_accessor :monitoring

    def monitoring
      return nil unless @monitoring
      el = "<oml_info oml_url=\"#{@monitoring[:oml_url]}\" domain=\"#{@monitoring[:domain]}\">"
      Nokogiri::XML(el).child
    end

    def before_save
      self.available = true if self.available.nil?
      super
    end

    def self.exclude_from_json
      sup = super
      [:sliver_type_id, :cmc_id, :location_id].concat(sup)
    end

    def self.include_nested_attributes_to_json
      sup = super
      [:interfaces, :cpus, :cmc, :location, :sliver_type, :leases, :usb_devices].concat(sup)
    end

    def self.can_be_managed?
      true
    end
  end
end
