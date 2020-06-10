#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||=
  File.expand_path('../../Gemfile', Pathname.new(__FILE__).realpath)

require 'rubygems'
require 'bundler/setup'
