# Matchmaker

Simple pattern matching library for ruby.

## Examples

### Simple match by class name

```ruby
require 'matchmaker'

class Dummy
  def initialize(x, y, z)
    @x, @y, @z = 1, 2, 3
  end

  def sum
    @x + @y + @z
  end
end

obj = Dummy.new(1, 2, 3)

Matchmaker.match(obj) do
  pattern Dummy do puts "Dummy class matched" end
end

# => Dummy class matched

```

### Matching by implemented methods and instance variables

```ruby
Matchmaker.match(obj) do
  pattern Dummy, :w do puts "obj does not have w" end
  pattern Dummy, :sum do puts "But it has a sum: #{sum}" end
end

# => But it has a sum: 6

# You don't even need to specify a class
Matchmaker.match(obj) do
  pattern :w do puts "obj does not have w" end
  pattern :sum do puts "But it has a sum" end
end

# => But it has a sum

```

### You can access instance variables and methods declared in the pattern

```ruby
Matchmaker.match(obj) do
  pattern Dummy, :x, :sum do puts "x is #{x}, sum is #{sum}" end
end

# => x is 1, sum is 6
```

### You can use `__` as a 'catch all' pattern
```ruby
Matchmaker.match(obj) do
  pattern Array do puts "obj is an array" end
  __ do puts "Default matcher matched" end
end

# => Default matcher matched
```

### Match a nil value with nil

```ruby
Matchmaker.match(nil) do
  pattern Dummy do puts "this does not match" end
  pattern nil do puts "I AM NIL!!!" end
end

# => I AM NIL!!!
```

### Gets even more interesting when using Array matchers

```ruby
array_obj = [1, 2, 3]

Matchmaker.match(array_obj) do
  enum :x do puts "Does not match because array_objs.size > 1"  end
  enum :x, :y, :z, :a do puts "does not match because it's too small" end
  enum :x, :y, :z do puts "You can access x: #{x}, y: #{y} and #{z}" end
end

# => You can access x: 1, y: 2 and 3

Matchmaker.match([]) do
  enum nil do puts "[] or nil matches any empty enum" end
end

# => [] or nil matches any empty enum

# You can use the `enum_cons` matcher to split the enum
Matchmaker.match(array_obj) do
  enum_cons :x, :xs do puts "You can access head #{x} and tail #{xs} of the enum" end
end

Matchmaker.match(array_obj) do
  enum_cons :x, :y, :xs do puts "More than one element before tail: #{y}" end
end

Matchmaker.match([1]) do
  enum_cons :x, :xs do puts "The tail can be empty: x: #{x}, xs: #{xs}" end
end

# => The tail can be empty: x: 1, xs: []
```

### Hashes are kind of supported ;)

```ruby
hash_obj = {a: 1, b: 2}

Matchmaker.match(hash_obj) do
    enum_cons :x, :y, :xs do puts "head: #{x}, y: #{y}, tail: #{xs}" end
end

# => head: [:a, 1], y: [:b, 2], tail: []

```

## Installation

Add this line to your application's Gemfile:

    gem 'match-maker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install match-maker

## Usage

See examples.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Have fun writing some code
4. Remember to run tests `ruby matchmaker_spec.rb`
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request
