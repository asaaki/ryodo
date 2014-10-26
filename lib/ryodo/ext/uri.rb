require "uri"

class URI::Generic
  alias_method :set_host_string, :set_host

  def set_host(value)
    @host = Ryodo.parse(set_host_string(value)) unless set_host_string(value).nil?
  end
end
