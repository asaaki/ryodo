# frozen_string_literal: true

module Kernel
  def Ryodo(domain_string)
    Ryodo.parse(domain_string)
  end

  def Ryodo?(domain_string)
    Ryodo.valid?(domain_string)
  end
end
