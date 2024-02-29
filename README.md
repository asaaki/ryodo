# ryodo

[![gem version](https://img.shields.io/gem/v/ryodo.svg?style=flat-square)](https://rubygems.org/gems/ryodo)
[![ci](https://github.com/asaaki/ryodo/workflows/ci/badge.svg)](https://github.com/asaaki/ryodo/actions?query=workflow:ci)
[![coverage status](https://img.shields.io/coveralls/asaaki/ryodo/master.svg?style=flat-square)](https://coveralls.io/r/asaaki/ryodo?branch=master)

**ryōdo【領土】 りょうど — A domain name parser using public suffix list**

Do you ever wanted to know if `suspicious.domain.name.blerp` is really a valid (registerable) domain?

Do you ever wanted to know what is the actual domain portion of `yet.another.awesome.domain.co.jp`?

Then you should try `ryodo` and get the answers!

Notice: This gem **does not** check DNS records to verify if a name was taken and registered, this is not its purpose.
I am a big fan of the UNIX philosophy: *»Write programs that do one thing and do it well.«*

My blog post about `ryodo`: [ryodo - domain parser (2012-06-02)](https://web.archive.org/web/20140606032232/https://markentier.de/codecraft/2012/06/02/ryodo-domain-parser/)


## Usage

```ruby
# Gemfile
gem 'ryodo'
```

```ruby
require 'ryodo'

dom = Ryodo.parse('my.awesome.domain.co.jp')
#=> Ryodo::Domain

                  #    SUBDOMAIN  DOMAIN   TLD
dom.tld           #=>                   'co.jp'  - public suffix
dom.domain        #=>            'domain.co.jp'  - registered/registrable domain
dom.sld           #=>            'domain'        - registered/registrable domain name w/o TLD
dom.subdomain     #=> 'my.awesome'               - subdomain parts
dom               #=> 'my.awesome.domain.co.jp'  - full domain string
dom.fqdn          #=> 'my.awesome.domain.co.jp.' - full domain + trailing dot

# all parts also reversable
# mostly used on domain/FQDN
dom.reverse            #=> 'jp.co.domain.awesome.my'
dom.fqdn.reverse       #=> '.jp.co.domain.awesome.my'

dom.to_a               #=> ['my','awesome','domain','co','jp']
dom.domain.to_a        #=> ['domain','co','jp']
dom.sld.to_a           #=> ['domain']
dom.subdomain.to_a     #=> ['my','awesome']
dom.fqdn.to_a          #=> ['my','awesome','domain','co','jp','']

# .to_a also usable with parameter :reverse (or shorthand :r)
dom.domain.to_a(:reverse) #=> ['jp','co','domain','awesome','my']
dom.fqdn.to_a(:reverse)   #=> ['','jp','co','domain','awesome','my']
dom.fqdn.to_a(:r)         #=> ['','jp','co','domain','awesome','my']
```


### Quick check (.domain_valid?)

```ruby
Ryodo.domain_valid?('my.awesome.domain.co.jp') #=> true
Ryodo.domain_valid?('co.jp')                   #=> false
```


### Kernel extension

```ruby
require 'ryodo/ext/kernel'

Ryodo('my.awesome.domain.co.jp')
#=> returns a Ryodo::Domain

Ryodo?('my.awesome.domain.co.jp')
#=> true
```

### String extension

```ruby
require 'ryodo/ext/string'

'my.awesome.domain.co.jp'.to_domain
'my.awesome.domain.co.jp'.ryodo

# validation
'my.awesome.domain.co.jp'.valid_domain?
```

In Gemfile:

```ruby
gem 'ryodo', require: %w[ryodo ryodo/ext/string]
```


### Extension of URI

Ryodo can transparently hook into URI, so you can use every described method on `.host`.

```ruby
require 'ryodo/ext/uri'

uri = URI.parse('http://my.awesome.domain.jp:5555/path')
uri.host
#=> 'my.awesome.domain.jp'

uri.host.class
#=> Ryodo::Domain
# but decorates the String class transparently

uri.host.domain
#=> 'domain.com'

# awesome quick check before doing further stuff with URI
# because why you would do a request to an URI with obviously invalid domain?
uri.host.is_valid?
#=> true
```

In Gemfile:

```ruby
gem 'ryodo', require: %w[ryodo ryodo/ext/uri]
```


## License

Licensed under MIT license ([LICENSE](LICENSE) or http://opensource.org/licenses/MIT)
