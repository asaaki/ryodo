# encoding: utf-8

module Ryodo
  class Rule < Struct.new(:exception, :stopOK, :children)

    def has_children?
      !children.empty?
    end

    def is_suffix?
      stopOK
    end

  end
end
