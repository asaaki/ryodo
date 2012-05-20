# encoding: utf-8
$KCODE = "UTF-8" if RUBY_VERSION =~ /^1\.8\.7/

module Ryodo
  module Convenience
    module U

      # Unicode junkie? ;o)
      alias_method :"ryōdo", :Ryodo
      alias_method :"領土", :Ryodo
      alias_method :"りょうど", :Ryodo

    end

  end
end

include Ryodo::Convenience::U