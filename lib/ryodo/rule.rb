module Ryodo
  class Rule < Struct.new(:exception, :stop_ok, :children)
    def children?
      !children.empty?
    end
    alias :has_children? :children?

    def suffix?
      stop_ok
    end
    alias :is_suffix? :suffix?
  end
end
