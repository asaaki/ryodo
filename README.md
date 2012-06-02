# ryodo [![](https://secure.travis-ci.org/asaaki/ryodo.png)](http://travis-ci.org/asaaki/ryodo)

**ryōdo【領土】 りょうど — A domain name parser**

----

**r2 branch!**

----

This is a pure Ruby implementation of the [regdomr](https://github.com/asaaki/regdomr) gem, but with slightly different API.

Without the Cext backend it should be also easily usable with Ruby implemenations like JRuby.

_nothing to see here, check later…_

## Ryodo (method)

This is a convenient shorthand to [Ryodo.parse](#ryodo-module)

```ruby
dom = Ryodo("my.awesome.domain.co.jp")
#=> Ryodo::Domain

                  #    SUBDOMAIN  DOMAIN   TLD
dom.tld           #=>                   "co.jp"
dom.regdomain     #=>            "domain.co.jp"
dom.subdomain     #=> "my.awesome"
dom.domain        #=> "my.awesome.domain.co.jp"
dom.cookie_domain #=>            "domain.co.jp" - lowest possible cookie domain

dom.fqdn
#=> "my.awesome.domain.co.jp."
# with trailing dot (root element is last part = empty string)
#   useful for DNS

# all parts also reversable
# mostly used on domain/FQDN
dom.domain(:reverse) #=> "my.awesome.domain.co.jp"
dom.fqdn(:reverse)   #=> ".jp.co.domain.awesome.my"

dom.regdomain.to_a     #=> ["domain","co","jp"]
dom.subdomain.to_a     #=> ["my","awesome"]
dom.domain.to_a        #=> ["my","awesome","domain","co","jp"]
dom.fqdn.to_a          #=> ["my","awesome","domain","co","jp",""]

# .to_a also usable with parameter :reverse (or shorthand :r)
dom.domain.to_a(:reverse) #=> ["jp","co","domain","awesome","my"]
dom.fqdn.to_a(:reverse)   #=> ["","jp","co","domain","awesome","my"]
dom.fqdn.to_a(:r)         #=> ["","jp","co","domain","awesome","my"]
```

## Ryodo (module)

**Ryodo.parse(…)** does the same as [`Ryodo(…)`](#ryodo-method)

`Ryodo[…]` - alias for `Ryodo.parse`

## Ryodo::Domain

The internal representation of a parsed domain string by `Ryodo.parse`.

## Ryodo::SuffixList

This is the interface for the public suffix list.

## Ryodo::SuffixListFetcher

Used to fetch a recent version of the public suffix list.
Mostly you don't need to, because the list won't change so often.

It's a helper for me to update if necessary.
So this module isn't automatically required when using this gem.

## Foo …

"Uh, excuse me Sir … just one more question." — Columbo (Peter Falk †)
