#!/usr/bin/env ruby
$LOAD_PATH << "lib"
require "ryodo"

module SuffixChecker
  module_function

  def check_public_suffix(query, expectation)
    query      = Ryodo.parse(query)
    calculated = query.domain.nil? ? "NULL" : query.domain
    result     = calculated == expectation
    passed     = result ? "  OK" : "FAIL"

    puts "#{passed} === Q: #{query.ljust(26)} | #{expectation.rjust(16)} <=> #{calculated.ljust(16)}"

    result
  end

  def run!
    results = []

    # Following test data can be found at:
    # <http://mxr.mozilla.org/mozilla-central/source/netwerk/test/unit/data/test_psl.txt?raw=1>

    # NULL input.
    results << check_public_suffix("NULL", "NULL")
    # Mixed case.
    results << check_public_suffix("COM", "NULL")
    results << check_public_suffix("example.COM", "example.com")
    results << check_public_suffix("WwW.example.COM", "example.com")
    # Leading dot.
    results << check_public_suffix(".com", "NULL")
    results << check_public_suffix(".example", "NULL")
    results << check_public_suffix(".example.com", "NULL")
    results << check_public_suffix(".example.example", "NULL")
    # Unlisted TLD.
    results << check_public_suffix("example", "NULL")
    results << check_public_suffix("example.example", "example.example")
    results << check_public_suffix("b.example.example", "example.example")
    results << check_public_suffix("a.b.example.example", "example.example")
    # Listed, but non-Internet, TLD.
    # results << check_public_suffix('local', 'NULL')
    # results << check_public_suffix('example.local', 'NULL')
    # results << check_public_suffix('b.example.local', 'NULL')
    # results << check_public_suffix('a.b.example.local', 'NULL')
    # TLD with only 1 rule.
    results << check_public_suffix("biz", "NULL")
    results << check_public_suffix("domain.biz", "domain.biz")
    results << check_public_suffix("b.domain.biz", "domain.biz")
    results << check_public_suffix("a.b.domain.biz", "domain.biz")
    # TLD with some 2-level rules.
    results << check_public_suffix("com", "NULL")
    results << check_public_suffix("example.com", "example.com")
    results << check_public_suffix("b.example.com", "example.com")
    results << check_public_suffix("a.b.example.com", "example.com")
    results << check_public_suffix("uk.com", "NULL")
    results << check_public_suffix("example.uk.com", "example.uk.com")
    results << check_public_suffix("b.example.uk.com", "example.uk.com")
    results << check_public_suffix("a.b.example.uk.com", "example.uk.com")
    results << check_public_suffix("test.ac", "test.ac")
    # TLD with only 1 (wildcard) rule.
    results << check_public_suffix("cy", "NULL")
    results << check_public_suffix("c.cy", "NULL")
    results << check_public_suffix("b.c.cy", "b.c.cy")
    results << check_public_suffix("a.b.c.cy", "b.c.cy")
    # More complex TLD.
    results << check_public_suffix("jp", "NULL")
    results << check_public_suffix("test.jp", "test.jp")
    results << check_public_suffix("www.test.jp", "test.jp")
    results << check_public_suffix("ac.jp", "NULL")
    results << check_public_suffix("test.ac.jp", "test.ac.jp")
    results << check_public_suffix("www.test.ac.jp", "test.ac.jp")
    results << check_public_suffix("kyoto.jp", "NULL")
    results << check_public_suffix("test.kyoto.jp", "test.kyoto.jp")
    results << check_public_suffix("ide.kyoto.jp", "NULL")
    results << check_public_suffix("b.ide.kyoto.jp", "b.ide.kyoto.jp")
    results << check_public_suffix("a.b.ide.kyoto.jp", "b.ide.kyoto.jp")
    results << check_public_suffix("c.kobe.jp", "NULL")
    results << check_public_suffix("b.c.kobe.jp", "b.c.kobe.jp")
    results << check_public_suffix("a.b.c.kobe.jp", "b.c.kobe.jp")
    results << check_public_suffix("city.kobe.jp", "city.kobe.jp")
    results << check_public_suffix("www.city.kobe.jp", "city.kobe.jp")
    # TLD with a wildcard rule and exceptions.
    results << check_public_suffix("ck", "NULL")
    results << check_public_suffix("test.ck", "NULL")
    results << check_public_suffix("b.test.ck", "b.test.ck")
    results << check_public_suffix("a.b.test.ck", "b.test.ck")
    results << check_public_suffix("www.ck", "www.ck")
    results << check_public_suffix("www.www.ck", "www.ck")
    # US K12.
    results << check_public_suffix("us", "NULL")
    results << check_public_suffix("test.us", "test.us")
    results << check_public_suffix("www.test.us", "test.us")
    results << check_public_suffix("ak.us", "NULL")
    results << check_public_suffix("test.ak.us", "test.ak.us")
    results << check_public_suffix("www.test.ak.us", "test.ak.us")
    results << check_public_suffix("k12.ak.us", "NULL")
    results << check_public_suffix("test.k12.ak.us", "test.k12.ak.us")
    results << check_public_suffix("www.test.k12.ak.us", "test.k12.ak.us")
    # IDN labels.
    results << check_public_suffix("食狮.com.cn", "食狮.com.cn")
    results << check_public_suffix("食狮.公司.cn", "食狮.公司.cn")
    results << check_public_suffix("www.食狮.公司.cn", "食狮.公司.cn")
    results << check_public_suffix("shishi.公司.cn", "shishi.公司.cn")
    results << check_public_suffix("公司.cn", "NULL")
    results << check_public_suffix("食狮.中国", "食狮.中国")
    results << check_public_suffix("www.食狮.中国", "食狮.中国")
    results << check_public_suffix("shishi.中国", "shishi.中国")
    results << check_public_suffix("中国", "NULL")
    # Same as above, but punycoded.
    results << check_public_suffix('xn--85x722f.com.cn', 'xn--85x722f.com.cn')
    # results << check_public_suffix('xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn')
    # results << check_public_suffix('www.xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn')
    # results << check_public_suffix('shishi.xn--55qx5d.cn', 'shishi.xn--55qx5d.cn')
    # results << check_public_suffix('xn--55qx5d.cn', 'NULL')
    # results << check_public_suffix('xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s')
    # results << check_public_suffix('www.xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s')
    # results << check_public_suffix('shishi.xn--fiqs8s', 'shishi.xn--fiqs8s')
    results << check_public_suffix('xn--fiqs8s', 'NULL')

    exit_code = results.all? ? 0 : 1
    case exit_code
    when 0 then puts "All okay! ✔"
    when 1 then puts "Some checks failed! ✘"
    end
    exit(exit_code)
  end
end

SuffixChecker.run!
