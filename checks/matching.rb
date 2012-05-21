# encoding: utf-8
$:<<"lib"
require "ryodo"

def checkPublicSuffix query, result

  q          = Ryodo::Query.new(query)
  cleaned    = q.instance_variable_get(:@raw_query)
  m          = q.best_match
  calculated = m.nil? ? "NULL" : m.result[:cookie].reverse.join(".")
  passed     = (calculated==result) ? "  OK" : "FAIL"

  puts "#{passed} === Q: #{query.ljust(20)} | EXPECTED: #{result.ljust(20)} | GOT: #{calculated.ljust(20)}"
end

# NULL input.
checkPublicSuffix('NULL', 'NULL')
# Mixed case.
checkPublicSuffix('COM', 'NULL')
checkPublicSuffix('example.COM', 'example.com')
checkPublicSuffix('WwW.example.COM', 'example.com')
# Leading dot.
checkPublicSuffix('.com', 'NULL')
checkPublicSuffix('.example', 'NULL')
checkPublicSuffix('.example.com', 'NULL')
checkPublicSuffix('.example.example', 'NULL')
# Leading dot for reversed FQDN
checkPublicSuffix('.com.example', 'example.com')
# Unlisted TLD.
checkPublicSuffix('example', 'NULL')
checkPublicSuffix('example.example', 'NULL')
checkPublicSuffix('b.example.example', 'NULL')
checkPublicSuffix('a.b.example.example', 'NULL')
# Listed, but non-Internet, TLD.
#checkPublicSuffix('local', 'NULL')
#checkPublicSuffix('example.local', 'NULL')
#checkPublicSuffix('b.example.local', 'NULL')
#checkPublicSuffix('a.b.example.local', 'NULL')
# TLD with only 1 rule.
checkPublicSuffix('biz', 'NULL')
checkPublicSuffix('domain.biz', 'domain.biz')
checkPublicSuffix('b.domain.biz', 'domain.biz')
checkPublicSuffix('a.b.domain.biz', 'domain.biz')
# TLD with some 2-level rules.
checkPublicSuffix('com', 'NULL')
checkPublicSuffix('example.com', 'example.com')
checkPublicSuffix('b.example.com', 'example.com')
checkPublicSuffix('a.b.example.com', 'example.com')
checkPublicSuffix('uk.com', 'NULL')
checkPublicSuffix('example.uk.com', 'example.uk.com')
checkPublicSuffix('b.example.uk.com', 'example.uk.com')
checkPublicSuffix('a.b.example.uk.com', 'example.uk.com')
checkPublicSuffix('test.ac', 'test.ac')
# TLD with only 1 (wildcard) rule.
checkPublicSuffix('cy', 'NULL')
checkPublicSuffix('c.cy', 'NULL')
checkPublicSuffix('b.c.cy', 'b.c.cy')
checkPublicSuffix('a.b.c.cy', 'b.c.cy')
# More complex TLD.
checkPublicSuffix('jp', 'NULL')
checkPublicSuffix('test.jp', 'test.jp')
checkPublicSuffix('www.test.jp', 'test.jp')
checkPublicSuffix('ac.jp', 'NULL')
checkPublicSuffix('test.ac.jp', 'test.ac.jp')
checkPublicSuffix('www.test.ac.jp', 'test.ac.jp')
checkPublicSuffix('kyoto.jp', 'NULL')
checkPublicSuffix('c.kyoto.jp', 'NULL')
checkPublicSuffix('b.c.kyoto.jp', 'b.c.kyoto.jp')
checkPublicSuffix('a.b.c.kyoto.jp', 'b.c.kyoto.jp')
checkPublicSuffix('pref.kyoto.jp', 'pref.kyoto.jp')  # Exception rule.
checkPublicSuffix('www.pref.kyoto.jp', 'pref.kyoto.jp')  # Exception rule.
checkPublicSuffix('city.kyoto.jp', 'city.kyoto.jp')  # Exception rule.
checkPublicSuffix('www.city.kyoto.jp', 'city.kyoto.jp')  # Exception rule.
# TLD with a wildcard rule and exceptions.
checkPublicSuffix('om', 'NULL')
checkPublicSuffix('test.om', 'NULL')
checkPublicSuffix('b.test.om', 'b.test.om')
checkPublicSuffix('a.b.test.om', 'b.test.om')
checkPublicSuffix('songfest.om', 'songfest.om')
checkPublicSuffix('www.songfest.om', 'songfest.om')
# US K12.
checkPublicSuffix('us', 'NULL')
checkPublicSuffix('test.us', 'test.us')
checkPublicSuffix('www.test.us', 'test.us')
checkPublicSuffix('ak.us', 'NULL')
checkPublicSuffix('test.ak.us', 'test.ak.us')
checkPublicSuffix('www.test.ak.us', 'test.ak.us')
checkPublicSuffix('k12.ak.us', 'NULL')
checkPublicSuffix('test.k12.ak.us', 'test.k12.ak.us')
checkPublicSuffix('www.test.k12.ak.us', 'test.k12.ak.us')