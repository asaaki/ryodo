module Ryodo
  class RuleSet
    def initialize
      @tree = {}
      build
    end

    def match(path)
      suffix, domain, match = find_match_parts(path, [], [], nil)
      suffix.push(domain.shift) if match && !match.exception
      # only if match has no children with domain and domain is present
      [suffix, [domain.shift], domain] if match && domain[0] && !match.children.keys.include?(domain[0])
    end

    private

    def build
      Ryodo::SuffixList.list.each { |line| build_line(line) }
    end

    def build_line(line)
      line.each.with_index do |node_name, idx|
        node_name, node = find_node_by_rule(node_name, line)
        idx > 0 ? add_node_to_parent(node_name, node, idx, line) : add_node_to_tree(node_name, node)
      end
    end

    def find_node_by_rule(node_name, line)
      stop_ok   = node_name == line.last
      exception = node_name[0] == "!"
      node_name = node_name[1..-1] if exception
      children  = {}
      [node_name, Ryodo::Rule.new(exception, stop_ok, children)]
    end

    def add_node_to_parent(node_name, node, index, line)
      end_idx = index - 1
      parent  = select_rule(line[0..end_idx])
      parent.children[node_name] = node unless parent.children[node_name]
    end

    def add_node_to_tree(node_name, node)
      @tree[node_name] = node unless @tree[node_name]
    end

    def select_rule(rule_path)
      return unless rule_path[-1]
      if rule_path[0..-2].empty?
        @tree[rule_path[-1]]
      else
        (rule = select_rule(rule_path[0..-2])) && rule.children[rule_path[-1]]
      end
    end

    def find_match_parts(path, suffix, domain, rule_match)
      until rule_match || path.empty?
        rule_match = find_rule_match(path)
        domain.unshift path.pop
        suffix = path
      end

      [suffix, domain, rule_match]
    end

    def find_rule_match(path)
      rule_match = select_rule(path) || select_rule(path.dup.fill("*", -1))
      rule_match && !rule_match.is_suffix? ? nil : rule_match
    end
  end
end
