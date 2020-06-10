# frozen_string_literal: true

class String
  def to_domain
    Ryodo.parse(self)
  end
  alias ryodo to_domain
  alias to_ryodo to_domain

  def valid_domain?
    Ryodo.domain_valid?(self)
  end
end
