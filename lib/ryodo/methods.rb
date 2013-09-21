# coding: utf-8

module Ryodo
  module Methods

    def parse domain_string
      Ryodo::Domain.new domain_string
    end
    alias_method :[], :parse

    def domain_valid? domain_string
      self.parse(domain_string).valid?
    end
    alias_method :valid_domain?, :domain_valid?
    alias_method :valid?,        :domain_valid?

  end
end
