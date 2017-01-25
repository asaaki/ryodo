module Ryodo
  module Methods
    def parse(domain_string)
      Ryodo::Domain.new(domain_string)
    end
    alias [] parse

    def domain_valid?(domain_string)
      parse(domain_string).valid?
    end
    alias valid_domain? domain_valid?
    alias valid? domain_valid?
  end
end
