# ryodo [![](https://secure.travis-ci.org/asaaki/ryodo.png)](http://travis-ci.org/asaaki/ryodo)

**ryōdo【領土】 りょうど — A domain name parser**

----

This is a pure Ruby implementation of the [regdomr](https://github.com/asaaki/regdomr) gem, but with slightly different API.

Without the Cext backend it should be also easily usable with Ruby implemenations like JRuby.

**Works only with Ruby 1.9.x!**

## Usage

```ruby
dom = Ryodo.parse("my.awesome.domain.co.jp")
#=> Ryodo::Domain

                  #    SUBDOMAIN  DOMAIN   TLD
dom.tld           #=>                   "co.jp"  - returns only the public suffix
dom.domain        #=>            "domain.co.jp"  - returns only registered/registrable domain
dom.subdomain     #=> "my.awesome"               - returns only subdomain parts
dom               #=> "my.awesome.domain.co.jp"  - returns full domain string
dom.fqdn          #=> "my.awesome.domain.co.jp." - full domain + trailing dot

# all parts also reversable
# mostly used on domain/FQDN
dom.reverse            #=> "my.awesome.domain.co.jp"
dom.fqdn.reverse       #=> ".jp.co.domain.awesome.my"

dom.to_a               #=> ["my","awesome","domain","co","jp"]
dom.domain.to_a        #=> ["domain","co","jp"]
dom.subdomain.to_a     #=> ["my","awesome"]
dom.fqdn.to_a          #=> ["my","awesome","domain","co","jp",""]

# .to_a also usable with parameter :reverse (or shorthand :r)
dom.domain.to_a(:reverse) #=> ["jp","co","domain","awesome","my"]
dom.fqdn.to_a(:reverse)   #=> ["","jp","co","domain","awesome","my"]
dom.fqdn.to_a(:r)         #=> ["","jp","co","domain","awesome","my"]
```

You can call it in different ways:

```ruby
Ryodo.parse("my.awesome.domain.co.jp")
Ryodo("my.awesome.domain.co.jp")
Ryodo["my.awesome.domain.co.jp"]
ryodo("my.awesome.domain.co.jp")

# String extension
"my.awesome.domain.co.jp".to_domain
"my.awesome.domain.co.jp".ryodo
```

UTF-8 junkie? ;o)

```ruby
# encoding: utf-8
ryōdo("my.awesome.domain.co.jp")
領土("my.awesome.domain.co.jp")
りょうど("my.awesome.domain.co.jp")
```

## Foo …

"Uh, excuse me Sir … just one more question." — Columbo (Peter Falk †)

## License

MIT/X11 — see `LICENSE.txt`

(c) 2012 Christoph Grabo