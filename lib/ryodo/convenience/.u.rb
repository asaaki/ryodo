# encoding: utf-8

module Ryodo
  module Convenience
    module U

      alias_method :ryodo, :Ryodo

      # Unicode junkie? ;o)
      alias_method :"ryōdo", :Ryodo
      alias_method :"領土", :Ryodo
      alias_method :"りょうど", :Ryodo

    end

  end
end

include Ryodo::Convenience::U