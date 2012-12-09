module Matchmaker
  module Enum
    class HashBindings
      def initialize(enum, bindings)
        @bindings = bindings
      end

      def each_name(&block)
        @bindings.keys.each(&block)
      end

      def get(name)
        @bindings[name]
      end
    end

    class EnumMatcher
      def initialize(subject)
        @subject = subject
      end

      def subject_matches?(*args)
        return false unless @subject.is_a?(Enumerable)
        return true if @subject.empty? && (args == [nil] || args == [[]])
        @subject.size == args.size
      end

      def eval(*args, block)
        if args == [nil] || args == [[]]
          hash_bindings = {}
        else
          hash_bindings = Hash[args.zip(@subject)]
        end

        bindings = HashBindings.new(@subject, hash_bindings)
        Evaluator.new.run_block(bindings, block)
      end
    end
  end
end
