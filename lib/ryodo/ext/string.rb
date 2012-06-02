class String

  def to_domain
    Ryodo.parse self
  end
  alias_method :ryodo,    :to_domain
  alias_method :to_ryodo, :to_domain

end