# frozen_string_literal: true
module Ryodo
  module Convenience
    module UTF8
      alias ryodo Ryodo

      alias ryodo? Ryodo?
      alias valid_domain? Ryodo?

      # Unicode junkie? ;o)
      alias ryōdo Ryodo
      alias ryōdo? Ryodo?

      alias 領土 Ryodo
      alias りょうど Ryodo

      alias 領土? Ryodo?
      alias りょうどか Ryodo?
      alias りょうどか。 Ryodo?
    end
  end
end

include Ryodo::Convenience::UTF8
