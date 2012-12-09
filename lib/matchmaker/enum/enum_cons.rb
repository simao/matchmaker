module Matchmaker
  module Enum
    class EnumBindings
      def initialize(enum, names)
        @bindings = build_bindings(enum, names)
      end

      def build_bindings(enum, names)
        return {} if names == [nil] || names == [[]] || names == [{}]
        enum = enum.dup
        res = {}

        names.each_with_index do |name, i|
          e = enum.shift

          if e.nil?
            res[name] = []
            break
          elsif i == names.size - 1
            res[name] = enum.unshift(e)
          else
            res[name] = e
          end
        end

        res
      end

      def each_name(&block)
        @bindings.keys.each(&block)
      end

      def get(name)
        @bindings[name]
      end
    end

    class EnumConsMatcher
      def initialize(subject)
        @subject = subject
      end

      def subject_matches?(*args)
        return false unless @subject.is_a?(Enumerable)
        return true if @subject.empty? && (args == [nil] || args == [[]])
        @subject.size >= (args.size - 1)
      end

      def eval(*args, block)
        Evaluator.new.run_block(EnumBindings.new(@subject, args), block)
      end
    end
  end
end
