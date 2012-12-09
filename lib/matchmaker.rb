# -*- coding: utf-8 -*-

require 'matchmaker/version'
require 'matchmaker/matcher'

require 'matchmaker/evaluator'
require 'matchmaker/class_matcher'
require 'matchmaker/default_matcher'
require 'matchmaker/enum'

module Matchmaker
  class NoMatchError < RuntimeError; end

  def self.matchers
    {
      :__ => DefaultMatcher,
      :pattern => ClassMatcher,
      :enum_cons => Enum::EnumConsMatcher,
      :enum => Enum::EnumMatcher
    }
  end

  def self.default_matcher(subject)
    Matcher.new(subject, matchers)
  end

  def self.match(subject, &block)
    default_matcher(subject).match(&block)
  end

  class << self
    alias_method :marry, :match
  end
end
