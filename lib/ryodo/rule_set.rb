# encoding: utf-8

module Ryodo
  class RuleSet

    def initialize
      @tree = {}
      build!
    end

    def build!
      Ryodo::SuffixList.list.each do |line|

        line.each.with_index do |node_name, idx|

          stopOK = node_name == line.last
          exception = node_name[0] == "!"
          node_name = node_name[1..-1] if exception
          children = {}

          node = Ryodo::Rule.new(exception, stopOK, children)

          if idx > 0
            end_idx = idx - 1
            parent = select_rule(line[0..end_idx])
            parent.children[node_name] = node unless parent.children[node_name]

          else
            @tree[node_name] = node unless @tree[node_name]
          end

        end

      end
    end

    def select_rule(rule_path)
      if rule_path[-1]
        if rule_path[0..-2].empty?
          @tree[rule_path[-1]]
        else
          rule = select_rule(rule_path[0..-2]) and rule.children[rule_path[-1]]
        end
      end
    end

    def match(path)
      suffix, domain, match = [], [], nil

      until match || path.empty?
        match = select_rule(path) || select_rule(path.dup.fill("*",-1))
        match = nil if match && !match.is_suffix?
        domain.unshift path.pop
        suffix = path
      end

      suffix.push(domain.shift) if match && !match.exception

      # only if match has no children with domain and domain is present
      if match && !match.children.keys.include?(domain[0]) && domain[0]
        [ suffix, [domain.shift], domain ]
      end
    end

  end
end
