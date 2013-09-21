# encoding: utf-8
require "uri"

class URI::Generic

  alias_method :set_host_string, :set_host

  def set_host(v)
    @host = Ryodo.parse(self.set_host_string(v)) unless self.set_host_string(v).nil?
  end

end
