# ryodo

[![gem version](https://badge.fury.io/rb/ryodo.png)](http://badge.fury.io/rb/ryodo) [![build status](https://secure.travis-ci.org/asaaki/ryodo.png)](http://travis-ci.org/asaaki/ryodo) [![dev dependency status](https://gemnasium.com/asaaki/ryodo.png)](https://gemnasium.com/asaaki/ryodo) [![code climate](https://codeclimate.com/github/asaaki/ryodo.png)](https://codeclimate.com/github/asaaki/ryodo) [![coverage status](https://coveralls.io/repos/asaaki/ryodo/badge.png?branch=master)](https://coveralls.io/r/asaaki/ryodo?branch=master)

**ryōdo【領土】 りょうど — A domain name parser using public suffix list**

Do you ever wanted to know if `suspicious.domain.name.blerp` is really a valid domain?

Do you ever wanted to know what is the domain portion of `others.guy.awesome.domain.co.jp`?

Then you should try `ryodo` and get the answers!

Notice: This gem **does not** check DNS records to verify if a name was taken and registered, this is not its purpose.
I am a big fan of the UNIX philosophy: *»Write programs that do one thing and do it well.«*

My blog post about `ryodo`: [ryodo - domain parser (2012-06-02)](http://codecraft.io/2012/06/02/ryodo-domain-parser/)


## Usage

```ruby
dom = Ryodo.parse("my.awesome.domain.co.jp")
#=> Ryodo::Domain

                  #    SUBDOMAIN  DOMAIN   TLD
dom.tld           #=>                   "co.jp"  - returns only the public suffix
dom.domain        #=>            "domain.co.jp"  - returns only registered/registrable domain
dom.sld           #=>            "domain"        - returns only registered/registrable domain name w/o TLD
dom.subdomain     #=> "my.awesome"               - returns only subdomain parts
dom               #=> "my.awesome.domain.co.jp"  - returns full domain string
dom.fqdn          #=> "my.awesome.domain.co.jp." - full domain + trailing dot

# all parts also reversable
# mostly used on domain/FQDN
dom.reverse            #=> "jp.co.domain.awesome.my"
dom.fqdn.reverse       #=> ".jp.co.domain.awesome.my"

dom.to_a               #=> ["my","awesome","domain","co","jp"]
dom.domain.to_a        #=> ["domain","co","jp"]
dom.sld.to_a           #=> ["domain"]
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
```


### Quick check (.domain_valid?)

```ruby
Ryodo.domain_valid?("my.awesome.domain.co.jp") #=> true
Ryodo.domain_valid?("co.jp")                   #=> false

# aliases
Ryodo.valid_domain?("my.awesome.domain.co.jp")
Ryodo.valid?("my.awesome.domain.co.jp")
Ryodo?("my.awesome.domain.co.jp")
ryodo?("my.awesome.domain.co.jp")
valid_domain?("my.awesome.domain.co.jp")
```


### String extension

```ruby
require "ryodo/ext/string"

"my.awesome.domain.co.jp".to_domain
"my.awesome.domain.co.jp".ryodo

# validation
"my.awesome.domain.co.jp".valid_domain?
```

In Gemfile:

```ruby
gem "ryodo", :require => ["ryodo", "ryodo/ext/string"]
```


### UTF-8 junkie?

```ruby
# coding: utf-8
require "ryodo/convenience/utf8"

ryōdo("my.awesome.domain.co.jp")
領土("my.awesome.domain.co.jp")
りょうど("my.awesome.domain.co.jp")

ryōdo?("my.awesome.domain.co.jp")
領土?("my.awesome.domain.co.jp")
りょうどか("my.awesome.domain.co.jp")
```


### Extension of URI

Ryodo can transparently hook into URI, so you can use every described method on `.host`.

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

# awesome quick check before doing further stuff with URI
# because why you would do a request to an URI with obviously invalid domain?
uri.host.is_valid?
#=> true
```

In Gemfile:

```ruby
gem "ryodo", :require => ["ryodo", "ryodo/ext/uri"]
```



## Benchmark

There is another gem called [public_suffix](https://github.com/weppos/publicsuffix-ruby), which does nearly the same (maybe with more features I don't need).

So I did a tiny benchmark.

**Setup**

A domain input list, taken by publicsuffix.org (checkPublicSuffix test script under [publicsuffix.org/list/](http://publicsuffix.org/list/)).

Some of them are also invalid (to test, if you implementation works correctly).

I added some very long domain names with many parts (for look-up time scale).

We only do a basic parsing and retrieve the registered/registrable domain. (Should hit the most important code of the gems.)

The benchmark script can be found at [checks/benchmark.rb (branch: prof)](./blob/prof/checks/benchmark.rb).

**Notes**

`PublicSuffix.parse(…)` will raise errors if domain input is invalid (e.g. not a registrable domain).

`Ryodo.parse(…)` won't raise but return nil values for invalid stuff (it only raises if input is not a String, of course).

**Results**

```
Ruby: MRI 2.0.0-p247
ryodo (0.2.4.1)
public_suffix (1.3.1)
Machine: AMD Phenom(tm) II X6 1090T, 6 cores, 3.2 GHz; 8 GB RAM
Linux 3.10.9-1-ARCH x86_64 GNU/Linux

Benchmark of domain parsing
===========================

Number of loops: 1000
Number of items per loop: 100

Rehearsal ---------------------------------------------------
ryodo             2.780000   0.000000   2.780000 (  2.779690)
public_suffix    83.350000   0.000000  83.350000 ( 83.414578)
----------------------------------------- total: 86.130000sec

                      user     system      total        real
ryodo             2.830000   0.000000   2.830000 (  2.834630)
public_suffix    83.450000   0.000000  83.450000 ( 83.510037)

Ryodo vs. PublicSuffix

Ryodo is 29.46 times faster than PublicSuffix.

```

```
Ruby: MRI 1.9.3-p448
ryodo (0.2.4.1)
public_suffix (1.3.1)
Machine: AMD Phenom(tm) II X6 1090T, 6 cores, 3.2 GHz; 8 GB RAM
Linux 3.10.9-1-ARCH x86_64 GNU/Linux

Benchmark of domain parsing
===========================

Number of loops: 1000
Number of items per loop: 100

Rehearsal ---------------------------------------------------
ryodo             2.640000   0.000000   2.640000 (  2.642131)
public_suffix    80.710000   0.010000  80.720000 ( 80.770868)
----------------------------------------- total: 83.360000sec

                      user     system      total        real
ryodo             2.670000   0.000000   2.670000 (  2.664983)
public_suffix    80.930000   0.020000  80.950000 ( 80.998667)

Ryodo is 30.39 times faster than PublicSuffix.
```

Interestingly the public_suffix gem got even slower over time (and/or ruby versions)
compared to my first benchmark (<http://codecraft.io/2012/06/02/ryodo-domain-parser/>).



## TODO

Lot of specs missing, this first version of second approach was developed in playground mode. ;o)



## Foo …

"Uh, excuse me Sir … just one more question." — Columbo (Peter Falk †)



## License

MIT/X11 — see [`LICENSE`](./LICENSE)

(c) 2012—2013 Christoph Grabo


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/asaaki/ryodo/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

