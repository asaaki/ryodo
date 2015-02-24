#!/usr/bin/env ruby
$LOAD_PATH << "lib"
require "ryodo"

def checkPublicSuffix(query, expectation)
  query      = Ryodo[query]
  calculated = query.domain.nil? ? "NULL" : query.domain
  passed     = calculated == expectation ? "  OK" : "FAIL"

  puts "#{passed} === Q: #{query.ljust(26)} | #{expectation.rjust(16)} <=> #{calculated.ljust(16)}"
end

# NULL input.
checkPublicSuffix("NULL", "NULL")
# Mixed case.
checkPublicSuffix("COM", "NULL")
checkPublicSuffix("example.COM", "example.com")
checkPublicSuffix("WwW.example.COM", "example.com")
# Leading dot.
checkPublicSuffix(".com", "NULL")
checkPublicSuffix(".example", "NULL")
checkPublicSuffix(".example.com", "NULL")
checkPublicSuffix(".example.example", "NULL")
# Unlisted TLD.
checkPublicSuffix("example", "NULL")
checkPublicSuffix("example.example", "example.example")
checkPublicSuffix("b.example.example", "example.example")
checkPublicSuffix("a.b.example.example", "example.example")
# Listed, but non-Internet, TLD.
# checkPublicSuffix('local', 'NULL')
# checkPublicSuffix('example.local', 'NULL')
# checkPublicSuffix('b.example.local', 'NULL')
# checkPublicSuffix('a.b.example.local', 'NULL')
# TLD with only 1 rule.
checkPublicSuffix("biz", "NULL")
checkPublicSuffix("domain.biz", "domain.biz")
checkPublicSuffix("b.domain.biz", "domain.biz")
checkPublicSuffix("a.b.domain.biz", "domain.biz")
# TLD with some 2-level rules.
checkPublicSuffix("com", "NULL")
checkPublicSuffix("example.com", "example.com")
checkPublicSuffix("b.example.com", "example.com")
checkPublicSuffix("a.b.example.com", "example.com")
checkPublicSuffix("uk.com", "NULL")
checkPublicSuffix("example.uk.com", "example.uk.com")
checkPublicSuffix("b.example.uk.com", "example.uk.com")
checkPublicSuffix("a.b.example.uk.com", "example.uk.com")
checkPublicSuffix("test.ac", "test.ac")
# TLD with only 1 (wildcard) rule.
checkPublicSuffix("cy", "NULL")
checkPublicSuffix("c.cy", "NULL")
checkPublicSuffix("b.c.cy", "b.c.cy")
checkPublicSuffix("a.b.c.cy", "b.c.cy")
# More complex TLD.
checkPublicSuffix("jp", "NULL")
checkPublicSuffix("test.jp", "test.jp")
checkPublicSuffix("www.test.jp", "test.jp")
checkPublicSuffix("ac.jp", "NULL")
checkPublicSuffix("test.ac.jp", "test.ac.jp")
checkPublicSuffix("www.test.ac.jp", "test.ac.jp")
checkPublicSuffix("kyoto.jp", "NULL")
checkPublicSuffix("test.kyoto.jp", "test.kyoto.jp")
checkPublicSuffix("ide.kyoto.jp", "NULL")
checkPublicSuffix("b.ide.kyoto.jp", "b.ide.kyoto.jp")
checkPublicSuffix("a.b.ide.kyoto.jp", "b.ide.kyoto.jp")
checkPublicSuffix("c.kobe.jp", "NULL")
checkPublicSuffix("b.c.kobe.jp", "b.c.kobe.jp")
checkPublicSuffix("a.b.c.kobe.jp", "b.c.kobe.jp")
checkPublicSuffix("city.kobe.jp", "city.kobe.jp")
checkPublicSuffix("www.city.kobe.jp", "city.kobe.jp")
# TLD with a wildcard rule and exceptions.
checkPublicSuffix("ck", "NULL")
checkPublicSuffix("test.ck", "NULL")
checkPublicSuffix("b.test.ck", "b.test.ck")
checkPublicSuffix("a.b.test.ck", "b.test.ck")
checkPublicSuffix("www.ck", "www.ck")
checkPublicSuffix("www.www.ck", "www.ck")
# US K12.
checkPublicSuffix("us", "NULL")
checkPublicSuffix("test.us", "test.us")
checkPublicSuffix("www.test.us", "test.us")
checkPublicSuffix("ak.us", "NULL")
checkPublicSuffix("test.ak.us", "test.ak.us")
checkPublicSuffix("www.test.ak.us", "test.ak.us")
checkPublicSuffix("k12.ak.us", "NULL")
checkPublicSuffix("test.k12.ak.us", "test.k12.ak.us")
checkPublicSuffix("www.test.k12.ak.us", "test.k12.ak.us")
# IDN labels.
checkPublicSuffix("食狮.com.cn", "食狮.com.cn")
checkPublicSuffix("食狮.公司.cn", "食狮.公司.cn")
checkPublicSuffix("www.食狮.公司.cn", "食狮.公司.cn")
checkPublicSuffix("shishi.公司.cn", "shishi.公司.cn")
checkPublicSuffix("公司.cn", "NULL")
checkPublicSuffix("食狮.中国", "食狮.中国")
checkPublicSuffix("www.食狮.中国", "食狮.中国")
checkPublicSuffix("shishi.中国", "shishi.中国")
checkPublicSuffix("中国", "NULL")
# Same as above, but punycoded.
# checkPublicSuffix('xn--85x722f.com.cn', 'xn--85x722f.com.cn')
# checkPublicSuffix('xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn')
# checkPublicSuffix('www.xn--85x722f.xn--55qx5d.cn', 'xn--85x722f.xn--55qx5d.cn')
# checkPublicSuffix('shishi.xn--55qx5d.cn', 'shishi.xn--55qx5d.cn')
# checkPublicSuffix('xn--55qx5d.cn', 'NULL')
# checkPublicSuffix('xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s')
# checkPublicSuffix('www.xn--85x722f.xn--fiqs8s', 'xn--85x722f.xn--fiqs8s')
# checkPublicSuffix('shishi.xn--fiqs8s', 'shishi.xn--fiqs8s')
# checkPublicSuffix('xn--fiqs8s', 'NULL')
