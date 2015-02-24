module Ryodo
  class Rule < Struct.new(:exception, :stop_ok, :children)
    def children?
      !children.empty?
    end
    alias_method :has_children?, :children?

    def suffix?
      stop_ok
    end
    alias_method :is_suffix?, :suffix?
  end
end
