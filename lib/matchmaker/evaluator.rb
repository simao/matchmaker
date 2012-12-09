module Matchmaker
  class Evaluator
    def run_block(bindings, block)
      bindings.each_name do |name|
        define_singleton_method(name) do
          bindings.get(name)
        end
      end

      instance_eval(&block)
    end
  end
end
