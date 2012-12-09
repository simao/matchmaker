module Matchmaker
  class ClassMatcherBindings
    attr_reader :subject, :names

    def initialize(subject, names)
      @subject, @names = subject, names
    end

    def each_name(&block)
      @names.each(&block)
    end

    def get(name)
      if subject.instance_variable_defined?("@#{name}")
        subject.instance_variable_get("@#{name}")
      elsif subject.respond_to?(name)
        subject.send(name)
      end
    end
  end

  class ClassMatcher
    def initialize(subject)
      @subject = subject
    end

    def subject_matches?(*args)
      if args == [nil]
        klass = NilClass
        vars = []
      elsif !args.first.is_a?(Class)
        klass = Object
        vars = args
      else
        klass = args.first
        vars = args[1, args.size]
      end

      return false unless @subject.is_a?(klass)

      vars.all? do |v|
        @subject.instance_variable_defined?("@#{v}") || @subject.respond_to?(v)
      end
    end

    def eval(*args, block)
      vars = args.compact
      vars = args[1, args.size] if args.first.is_a?(Class)

      bindings = ClassMatcherBindings.new(@subject, vars)

      Evaluator.new.run_block(bindings, block)
    end
  end
end

