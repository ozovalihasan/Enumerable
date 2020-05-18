# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    block_given? ? size.times { |counter| yield(to_a[counter]) } : enum_for(__method__)
  end

  def my_each_with_index
    block_given? ? size.times { |counter| yield(self[counter], counter) } : enum_for(__method__)
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

  def my_all?(*question)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return false unless question[0] === item
      elsif block_given?
        return false unless yield(item)
      elsif [nil, false].include? item
        return false
      end
    end
    true
  end

  def my_any?(*question)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return true if question[0] === item
      elsif block_given?
        return true if yield(item)
      elsif ![nil, false].include? item
        return true
      end
    end
    false
  end

  def my_none?(*question)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return false if question[0] === item
      elsif block_given?
        return false if yield(item)
      elsif ![nil, false].include? item
        return false
      end
    end
    true
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

  def my_map
    return enum_for(__method__) unless block_given?

    result = []
    my_each do |item|
      result << yield(item)
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

a = [2, 3, 4]
p a.pop
p a
p 3.send(:<<, 2)
p (5...10).my_inject(:*)

# rubocop:enable Style/CaseEquality
p (1..4).my_map { |i| i*i }    
p (1..4).my_map  
p (5..10).my_inject { |sum, n| sum + n }            #=> 45

hash = Hash.new
%w(cat dog wombat).my_each_with_index { |item, index|
  hash[item] = index
}
p hash