require_relative 'spec_helper'

module Matchmaker
  class Dummy
    attr_reader :x, :y, :z

    def initialize(x, y, z)
      @x, @y, @z = x, y, z
    end

    def calculation
      x + y + z
    end
  end

  describe ClassMatcher do
    before do
      @obj = Dummy.new(1, 2, 3)
      @class_matcher = ClassMatcher.new(@obj)
    end

    describe "#subject_matches?" do
      it "matches if classname is the same" do
        @class_matcher.subject_matches?(Dummy).must_equal true
      end

      it "does not match if not all bindings are possible" do
        @class_matcher.subject_matches?(Dummy, :undefined).must_equal false
      end

      it "matches nil without using explicit NilClass" do
        @class_matcher = ClassMatcher.new(nil)
        @class_matcher.subject_matches?(nil).must_equal true
      end

      it "does not match nil pattern if it's not a NilClass object" do
        @class_matcher = ClassMatcher.new(@obj)
        @class_matcher.subject_matches?(nil).must_equal false
      end
    end
  end

  describe Matcher do
    describe "#match" do
      before do
        @matcher = Matcher.new(nil, Matchmaker.matchers)
      end

      it "only runs ONE matching block" do
        probe = 0

        @matcher.match do
          pattern nil do probe = 1 end
          __ do probe = 2 end
        end

        probe.must_equal 1
      end

      it "runs default block if exists" do
        probe = 0

        @matcher.match do
          pattern Dummy do probe = 1 end
          __ do probe = 2 end
        end

        probe.must_equal 2
      end

      it "raises exception if no pattern could be matched" do

        proc {
          @matcher.match do
            pattern Dummy do nil end
          end
        }.must_raise NoMatchError

      end

      it "returns the value of the applied match" do
        result = @matcher.match do
          __ { 22 }
        end

        result.must_equal 22
      end

      describe "#pattern" do
        before do
          @obj = Dummy.new(1, 2, 3)
          @matcher = Matcher.new(@obj, Matchmaker.matchers)
        end

        it "yields block when matching only class" do
          probe = @matcher.pattern(Dummy) do probe = true end
          probe.must_equal true
        end

        it "allows access to subject vars from block" do
          x_value = @matcher.pattern(Dummy, :x) do x end

          x_value.must_equal @obj.x
        end

        it "allows access to subject methods" do
          v = @matcher.pattern(Dummy, :calculation) do calculation end
          v.must_equal @obj.calculation
        end

        it "matches only methods/instance variables when not using class" do
          v = @matcher.pattern(:x, :y) do x end
          v.must_equal @obj.x
        end
      end
    end

    describe "#enum" do
      describe "with a non empty enum" do
        before do
          @obj = [1, 2, 3]
          @matcher = Matcher.new(@obj, Matchmaker.matchers)
        end

        it "matches array" do
          v = @matcher.enum(:x, :y, :z) do [x, y, z] end
          v.must_equal [1, 2, 3]
        end

        it "does not match if size is not the same" do
          v = @matcher.enum(:x) do true end
          v.must_be_nil
        end

        it "does not match if enum size is not big enough" do
          v = @matcher.enum(:x) do true end
          v.must_be_nil
        end

        it "does not match nil for empty subject" do
          v = @matcher.enum(nil) do true end
          v.must_be_nil
        end
      end

    end

    describe "with an empty enum" do
      before do
        @matcher = Matcher.new([], Matchmaker.matchers)
      end

      it "matches [] for empty subject" do
        v = @matcher.enum([]) do true end
        v.must_equal true
      end

      it "matches nil for empty subject" do
        v = @matcher.enum(nil) do true end
        v.must_equal true
      end
    end
  end

  describe "#enum_cons" do
    describe "with arrays" do
      before do
        @obj = [1, 2, 3]
        @matcher = Matcher.new(@obj, Matchmaker.matchers)
      end

      it "matches enumerable" do
        v = @matcher.enum_cons do 1 end
        v.must_equal 1
      end

      it "assigns head and tail" do
        head = nil
        tail = nil

        @matcher.enum_cons(:x, :xs) do head = x; tail = xs end

        head.must_equal 1
        tail.must_equal [2, 3]
      end

      it "assigns elements first and then tail" do
        head, head_y, tail = nil

        @matcher.enum_cons(:x, :y, :xs) do head = x; head_y = y; tail = xs end

        head.must_equal 1
        head_y.must_equal 2
        tail.must_equal [3]
      end

      it "allows to match an enum using an empty tail" do
        head, head_y, head_z, tail = nil

        @matcher.enum_cons(:x, :y, :z, :xs) do
          head = x
          head_y = y
          head_z = z
          tail = xs
        end

        head.must_equal 1
        head_y.must_equal 2
        head_z.must_equal 3
        tail.must_equal []
      end

      it "does not match if not enough elements in enum" do
        v = @matcher.enum_cons(:x, :y, :v, :z, :xs) do true end
        v.must_be_nil
      end

    end

    describe "with hashes" do
      before do
        @matcher = Matcher.new({:a => 1, :b => 2}, Matchmaker.matchers)
      end

      it "can match hashes" do
        x_, y_, z_ = nil

        @matcher.enum_cons(:x, :y, :z) do x_ = x; y_ = y; z_ = z end
        x_.must_equal([:a, 1])
        y_.must_equal([:b, 2])
        z_.must_equal([])
      end
    end

    describe "with empty enums" do
      before do
        @matcher = Matcher.new([], Matchmaker.matchers)
      end

      it "matches empty hash with matcher" do
        @matcher = Matcher.new({}, Matchmaker.matchers)
        v = @matcher.enum_cons({}) do true end
        v.must_equal true
      end

      it "matches empty array with nil matcher" do
        v = @matcher.enum_cons(nil) do true end
        v.must_equal true
      end

      it "matches empty array with empty enum instance" do
        v = @matcher.enum_cons([]) do true end
        v.must_equal true
      end
    end
  end

  describe "#__" do
    before do
      @obj = Dummy.new(1, 2, 3)
      @matcher = Matcher.new(@obj, Matchmaker.matchers)
    end

    it "always calls associated block" do
      probe = @matcher.__ do true end
      probe.must_equal true
    end
  end
end
