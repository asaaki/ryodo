# frozen_string_literal: true
require 'uri'

module URI
  class Generic
    alias set_host_string set_host

    # rubocop:disable Style/AccessorMethodName
    def set_host(value)
      @host = Ryodo.parse(set_host_string(value)) unless set_host_string(value).nil?
    end
    # rubocop:enable Style/AccessorMethodName
  end
end
