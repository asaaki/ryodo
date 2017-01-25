# frozen_string_literal: true
module Ryodo
  module Convenience
    # rubocop:disable Style/MethodName
    def Ryodo(domain_string)
      Ryodo.parse(domain_string)
    end

    def Ryodo?(domain_string)
      Ryodo.valid?(domain_string)
    end
    # rubocop:enable Style/MethodName
  end
end

include Ryodo::Convenience
