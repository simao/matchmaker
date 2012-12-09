module Matchmaker
  class EmptyBindings
    def each_name; end
  end

  class DefaultMatcher
    def initialize(*args); end

    def subject_matches?(*args)
      true
    end

    def eval(*args, block)
      Evaluator.new.run_block(EmptyBindings.new, block)
    end
  end
end
