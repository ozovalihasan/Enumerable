# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each(&block)
    block_given? ? size.times { |counter| block.call(to_a[counter]) } : enum_for(__method__)
  end

  def my_each_with_index(&block)
    block_given? ? size.times { |counter| block.call(self[counter], counter) } : enum_for(__method__)
  end

  def my_select(&block)
    if block_given?
      result = []
      my_each { |item| result << item if block.call(item) }
      return result
    end
    enum_for(__method__)
  end

  def multiple_argument_error?(*question)
    raise ArgumentError, "wrong number of arguments (given #{question[0].size}, expected 0..1)" if question[0].size > 1
  end

  def my_all?(*question, &block)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return false unless question[0] === item
      elsif block_given?
        return false unless block.call(item)
      elsif [nil, false].include? item
        return false
      end
    end
    true
  end

  def my_any?(*question, &block)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return true if question[0] === item
      elsif block_given?
        return true if block.call(item)
      elsif ![nil, false].include? item
        return true
      end
    end
    false
  end

  def my_none?(*question, &block)
    multiple_argument_error?(question)
    my_each do |item|
      if question.size == 1
        return false if question[0] === item
      elsif block_given?
        return false if block.call(item)
      elsif ![nil, false].include? item
        return false
      end
    end
    true
  end

  def my_count(*question, &block)
    multiple_argument_error?(question)
    result = 0
    my_each do |item|
      if question.size == 1
        result += 1 if question[0] === item
      elsif block_given?
        result += 1 if block.call(item)
      elsif question.size.zero?
        result += 1
      end
    end
    result
  end

  def my_map(&block)
    result = []
    my_each do |item|
      result << item if block.call(item)
    end
    return enum_for(__method__) unless block_given?

    result
  end

  def my_inject(*question, &block)
    sym = question.pop unless block_given?
    multiple_argument_error?(question)
    arr = [question, to_a].flatten
    initial = arr.shift
    memo = initial
    arr.my_each do |item|
      memo = block_given? ? block.call(memo, item) : memo.send(sym, item)
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
