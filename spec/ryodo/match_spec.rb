# encoding: utf-8
require File.expand_path("../../spec_helper.rb", __FILE__)

describe Ryodo::Match do

  context "tests" do

    # input and expectations matrix
    [

      [ ["jp"],                   ["jp","test"],                    [true, :rest],
        true, false, false, false, true,
        ["jp","test"], ["jp","test"], nil ],

      [ ["jp"],                   ["jp","test","www"],              [true, :rest, :rest],
        true, false, false, false, true,
        ["jp","test"], ["jp","test"], ["www"] ],

      [ ["jp","tokyo","*"],       ["jp","test"],                    [true, false, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["jp","tokyo","*"],       ["jp","tokyo"],                   [true, true, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["jp","tokyo","*"],       ["jp","tokyo","metro"],           [true, true, :wildcard],
        true, false, true, true, false,
        nil, nil, nil ],

      [ ["jp","tokyo","*"],       ["jp","tokyo","foo","bar"],       [true, true, :wildcard, :rest],
        true, false, true, false, true,
        ["jp","tokyo","foo","bar"], ["jp","tokyo","foo","bar"], nil ],

      [ ["jp","tokyo","*"],       ["jp","tokyo","foo","bar","baz"], [true, true, :wildcard, :rest, :rest],
        true, false, true, false, true,
        ["jp","tokyo","foo","bar"], ["jp","tokyo","foo","bar"], ["baz"] ],

      [ ["jp","tokyo","!metro"],  ["jp","test"],                    [true, false, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["jp","tokyo","!metro"],  ["jp","tokyo"],                   [true, true, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["jp","tokyo","!metro"],  ["jp","tokyo","metro"],           [true, true, :override],
        true, true, false, true, true,
        ["jp","tokyo","metro"], ["jp","tokyo","metro"], nil ],

      [ ["jp","tokyo","!metro"],  ["jp","tokyo","metro","foo"],     [true, true, :override, :rest],
        true, true, false, false, true,
        ["jp","tokyo","metro"], ["jp","tokyo","metro"], ["foo"] ],

      [ ["jp","tokyo","!metro"],  ["jp","tokyo","metro","foo", "bar"], [true, true, :override, :rest],
        true, true, false, false, true,
        ["jp","tokyo","metro"], ["jp","tokyo","metro"], ["foo","bar"] ],

      [ ["jp"],                   ["de"],                           [false, false],
        false, false, false, true, false,
        nil, nil, nil ],

      [ ["jp"],                   ["de","test"],                    [false, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["jp"],                   ["de","test","www"],              [false, false, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["uk","co"],              ["uk"],                           [true, false, false],
        false, false, false, false, false,
        nil, nil, nil ],

      [ ["uk","co"],              ["uk","co"],                      [true, true, false],
        false, false, false, true, false,
        nil, nil, nil ],

      [ ["uk","co"],              ["uk","co","test"],               [true, true, :rest],
        true, false, false, false, true,
        ["uk","co","test"], ["uk","co","test"], nil ],

      [ ["uk","co"],              ["uk","co","test","www"],         [true, true, :rest, :rest],
        true, false, false, false, true,
        ["uk","co","test"], ["uk","co","test"], ["www"] ]

    ].each do |suffix, query, rule,
               is_valid, is_exception, is_wildcard, is_exact_suffix, is_match,
               expected_domain, expected_cookie, expected_subdomain|

      # only for shorter output
      short_rule = rule.map do |e|
        e = :"T" if e == true
        e = :"F" if e == false
        e = :"W" if e == :wildcard
        e = :"!" if e == :override
        e = :"R" if e == :rest
        e
      end

      context "SUFFIX: #{suffix.reverse.join('.').ljust(15)} | QUERY: #{query.reverse.join('.').ljust(20)}" do

        before do
          @match = described_class.new(suffix, query, rule)
        end

        it "#is_valid?        checks for false value in given rule (expect: #{is_valid})" do
          @match.is_valid?.should == is_valid
        end

        it "#is_exception?    checks if rule is a override for wildcards (expect: #{is_exception})" do
          @match.is_exception?.should == is_exception
        end

        it "#is_wildcard?     checks if rule is a wildcard (expect: #{is_wildcard})" do
          @match.is_wildcard?.should == is_wildcard
        end

        it "#is_exact_suffix? checks if query is longer than suffix (expect: #{is_exact_suffix})" do
          @match.is_exact_suffix?.should == is_exact_suffix
        end

        it "#is_match?        checks if query is longer than suffix (expect: #{is_match})" do
          @match.is_match?.should == is_match
        end

        it "#get_domain       returns domain part if any (expect: #{expected_domain || 'nil'})" do
          @match.get_domain.should == expected_domain
        end

        it "#get_cookie       returns cookie domain part if any (expect: #{expected_cookie || 'nil'})" do
          @match.get_cookie.should == expected_cookie
        end

        it "#get_subdomain    returns subdomain part if any (expect: #{expected_subdomain || 'nil'})" do
          @match.get_subdomain.should == expected_subdomain
        end

      end

    end

  end


end