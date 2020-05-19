# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    size.times { |counter| yield(to_a[counter]) } if block_given?
    block_given? ? self : enum_for(__method__)
  end

  def my_each_with_index
    size.times { |counter| yield(self[counter], counter) } if block_given?
    block_given? ? self : enum_for(__method__)
  end

  def my_select
    if block_given?
      result = []
      my_each { |item| result << item if yield(item) }
      return result
    end
    enum_for(__method__)
  end

  def multiple_argument_error?(*question)
    raise ArgumentError, "wrong number of arguments (given #{question[0].size}, expected 0..1)" if question[0].size > 1
  end

  def all_any_none(question, arg1, arg2, *block)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return arg1 if (question[0] === item) == arg2
      elsif !block[0].nil?
        return arg1 if block[0].call(item) == arg2
      elsif ([nil, false].include? item) == !arg2
        return arg1
      end
    end
    !arg1
  end

  def my_all?(*question, &block)
    all_any_none(question, false, false, block)
  end

  def my_any?(*question, &block)
    all_any_none(question, true, true, block)
  end

  def my_none?(*question, &block)
    all_any_none(question, false, true, block)
  end

  def my_count(*question)
    multiple_argument_error?(question)
    result = 0
    my_each do |item|
      if question.size == 1
        result += 1 if question[0] === item
      elsif block_given?
        result += 1 if yield(item)
      elsif question.size.zero?
        result += 1
      end
    end
    result
  end

  def my_map(*proc)
    multiple_argument_error?(proc)
    return enum_for(__method__) if !block_given? && proc[0].nil?

    result = []
    my_each do |item|
      result << (!proc[0].nil? ? proc[0].call(item) : yield(item))
    end
    result
  end

  def my_inject(*question)
    sym = question.pop unless block_given?
    multiple_argument_error?(question)
    arr = [question, to_a].flatten
    initial = arr.shift
    memo = initial
    arr.my_each do |item|
      memo = block_given? ? yield(memo, item) : memo.send(sym, item)
    end
    memo
  end
end

# rubocop:enable Style/CaseEquality

def multiply_els(arr)
  arr.my_inject(:*)
end

p multiply_els([2, 4, 5])
proc = proc { |n| n * 3 }
p [2, 4, 5].my_map(proc) { |i| i * i }

# arr = [ true ]
# arr2 = %w[ant bear cat]
# words = ["none","any","all"]
# var = "none"
# words.each do |var|
# p eval("arr2.my_#{var}? { |word| word.length >= 3 } == arr2.#{var}? { |word| word.length >= 3 }")
# p eval("arr2.my_#{var}? { |word| word.length >= 4 } == arr2.#{var}? { |word| word.length >= 4 }")
# p eval("arr2.my_#{var}?(/d/)== arr2.#{var}?(/d/)")
# p eval("arr.my_#{var}?(Integer)== arr.#{var}?(Integer)")
# p eval("arr.my_#{var}? == arr.#{var}?")
# p eval("[].my_#{var}? == [].#{var}?")
# end
