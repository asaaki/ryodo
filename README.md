# ryodo [![](https://secure.travis-ci.org/asaaki/ryodo.png)](http://travis-ci.org/asaaki/ryodo)

**ryōdo【領土】 りょうど — A domain name parser**

_nothing to see here, check later…_

## Ryodo (method)

This is a convenient shorthand to [Ryodo.parse](#ryodo-module)

```ruby
dom = Ryodo("my.awesome.domain.co.jp")
#=> Ryodo::Domain

#                 SUBDOMAIN  DOMAIN TLD
dom.tld        =                   "co.jp"
dom.regdomain  =            "domain.co.jp"
dom.subdomain  = "my.awesome"
dom.domain     = "my.awesome.domain.co.jp"
dom.cookie_dom =            "domain.co.jp" # highest possible cookie domain

dom.fqdn = "my.awesome.domain.co.jp." # with trailing dot (root element)
                                      #   useful for DNS

dom.dnsr = ".jp.co.domain.awesome.my" # FQDN in reversed order, with leading dot for root element
                                      #   useful for recursive resolvers (DNS)
                                      #   (or Java-like package naming ;o)

dom.regdomain.to_a = ["domain","co","jp"]
dom.subdomain.to_a = ["my","awesome"]
dom.domain.to_a    = ["my","awesome","domain","co","jp"]
dom.dnsr.to_a      = ["jp","co","domain","awesome","my"] # root element removed!
```

## Ryodo (module)

**Ryodo.parse(…)** does the same as [`Ryodo(…)`](#ryodo-method)

`Ryodo[…]` - alias for `Ryodo.parse`

## Ryodo::Domain

## Ryodo::SuffixList

## Ryodo::SuffixListFetcher
