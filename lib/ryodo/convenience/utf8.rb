# coding: utf-8

module Ryodo
  module Convenience
    module UTF8

      alias_method :ryodo,         :Ryodo

      alias_method :ryodo?,        :Ryodo?
      alias_method :valid_domain?, :Ryodo?

      # Unicode junkie? ;o)
      alias_method :"ryōdo",   :Ryodo
      alias_method :"ryōdo?",  :Ryodo?

      alias_method :"領土",    :Ryodo
      alias_method :"りょうど", :Ryodo

      alias_method :"領土?",    :Ryodo?
      alias_method :"りょうどか", :Ryodo?
      alias_method :"りょうどか。", :Ryodo?

    end

  end
end

include Ryodo::Convenience::UTF8
