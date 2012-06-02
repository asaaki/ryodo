# encoding: utf-8

module Ryodo
  module Methods

    def parse domain_string
      Ryodo::Domain.new domain_string
    end
    alias_method :[], :parse

  end
end