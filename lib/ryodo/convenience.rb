# encoding: utf-8

module Ryodo
  module Convenience

    def Ryodo(domain_string)
      Ryodo.parse(domain_string)
    end

    def Ryodo?(domain_string)
      Ryodo.valid?(domain_string)
    end

  end
end

include Ryodo::Convenience
