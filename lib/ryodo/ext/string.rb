class String

  def to_domain
    Ryodo.parse self
  end
  alias_method :ryodo,    :to_domain
  alias_method :to_ryodo, :to_domain

  def valid_domain?
    Ryodo.domain_valid?(self)
  end

end
