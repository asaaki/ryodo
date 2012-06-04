# ryodo [![](https://secure.travis-ci.org/asaaki/ryodo.png)](http://travis-ci.org/asaaki/ryodo)

**ryōdo【領土】 りょうど — A domain name parser using public suffix list**

----

This is a pure Ruby implementation of the [regdomr](https://github.com/asaaki/regdomr) gem, but with slightly different API.

Without the Cext backend it should be also easily usable with Ruby implemenations like JRuby.

**Works only with Ruby 1.9.x!** (I dropped all support for 1.8.x)



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
dom.reverse            #=> "jp.co.domain.awesome.my"
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

### UTF-8 junkie?

```ruby
# encoding: utf-8
ryōdo("my.awesome.domain.co.jp")
領土("my.awesome.domain.co.jp")
りょうど("my.awesome.domain.co.jp")
```

### Extension of URI

```ruby
require "ryodo/ext/uri"

uri = URI.parse("http://my.awesome.domain.jp:5555/path")
uri.host
#=> "my.awesome.domain.jp"

uri.host.class
#=> Ryodo::Domain
# but decorates the String class transparently

uri.host.domain
#=> "domain.com"
```

In Gemfile:

```ruby
gem "ryodo", :require => ["ryodo","ryodo/ext/uri"]
```



## Benchmark

There is another gem called [public_suffix](https://github.com/weppos/public_suffix_service), which does nearly the same (maybe with more features I don't need).

So I did a tiny benchmark.

**Setup**

A domain input list, taken by publicsuffix.org (checkPublicSuffix test script under [publicsuffix.org/list/](http://publicsuffix.org/list/)).

Some of them are also invalid (to test, if you implementation works correctly).

I added some very long domain names with many parts (for look-up time scale).

Finally 72 entries to check.

Ruby: 1.9.3-p194, no special patches

We only do a basic parsing and retrieve the registered/registrable domain. (Should hit the most important code of the gems.)

**Test script snippet**

```ruby
# DOMAINS is the array of domain entries - shuffled on every benchmark run

LOOPS = 1_000

Benchmark.bmbm do |b|

  b.report "ryodo" do
    LOOPS.times do
      DOMAINS.each do |domain|
        Ryodo.parse(domain).domain # returns nil if not valid
      end
    end
  end

  b.report "public_suffix" do
    LOOPS.times do
      DOMAINS.each do |domain|
        PublicSuffix.parse(domain).domain rescue nil # it raises if not valid in any way, so we rescue it
      end
    end
  end

end
```

**Caveats**

`PublicSuffix.parse(…)` will raise errors if domain input is invalid (e.g. not a registrable domain).

`Ryodo.parse(…)` won't raise but return nil values for invalid stuff (it only raises if input is not a String, of course).

**Result**

```
Rehearsal -------------------------------------------------
ryodo           1.800000   0.000000   1.800000 (  1.809521)
public_suffix  21.880000   0.020000  21.900000 ( 21.907808)
--------------------------------------- total: 23.700000sec

                    user     system      total        real
ryodo           1.770000   0.000000   1.770000 (  1.769734)
public_suffix  22.320000   0.010000  22.330000 ( 22.346013)
```

As you can see, Ryodo is more than **10 times faster**.

_(Funfact: My first approach was 6 times slower — improvement factor of 60!)_




## TODO

Lot of specs missing, this first version of second approach was developed in playground mode. ;o)



## Foo …

"Uh, excuse me Sir … just one more question." — Columbo (Peter Falk †)



## License

MIT/X11 — see `LICENSE.txt`

(c) 2012 Christoph Grabo