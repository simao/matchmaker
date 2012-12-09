module Matchmaker
  class Matcher
    attr_accessor :subject

    def initialize(subject, matchers)
      @subject = subject
      @matched = false

      setup_matchers(matchers)
    end

    def match(&block)
      result = instance_eval(&block)
      raise NoMatchError unless @matched
      result
    end

    def call_matcher(klass, args, block)
      return false if @matched
      matcher = klass.new(subject)

      if matcher.subject_matches?(*args)
        @matched = true
        matcher.eval(*args, block)
      else
        nil
      end
    end

    def setup_matchers(matchers)
      matchers.each do |sym, klass|
        define_singleton_method(sym) do |*args, &block|
          call_matcher(klass, args, block)
        end
      end
    end
  end
end
