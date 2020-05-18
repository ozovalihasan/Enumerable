module Enumerable

  def my_each(&block)
    block_given? ? size.times { |counter| block.call(self.to_a[counter]) } : enum_for(__method__)
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
    raise ArgumentError.new("wrong number of arguments (given #{question[0].size}, expected 0..1)") if question[0].size>1
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
    multiple_argument_error?(question)
    result = []
    my_each do |item|
      result << item if block.call(item)
    end
    return enum_for(__method__) unless block_given?
    result

  end


end

#print 1, %w[ant bear cat].all? { |word| word.length >= 3 }
#p '==='
#print 2, %w[ant bear cat].my_all? { |word| word.length >= 3 } #=> true #=> true
#p '==='
#print 3, %w[ant bear cat].all? { |word| word.length >= 4 } 
#p '==='
#print 4, %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false#=> false
#p '==='
#print 5, %w[ttt].all?(/t/)                        
#p '==='
#print 6, %w[ttt].my_all?(/t/)                        #=> false#=> false
#p '==='
#print 7, [1, 2i, 3.14].all?(Numeric)                      
#p '==='
#print 8, [1, 2i, 3.14].my_all?(Numeric)                       #=> true #=> true
#p '==='
#print 9, [nil].all?                              
#p '==='
#print 10, [nil].my_all?                              #=> false#=> false
#p '==='
#print 11, [].all?                                          
#p '==='
#print 12, [].my_all?                                           #=> true #=> true
#p '==='
#
word = "none?"

a = %w{d d ddf}
p a.my_any? { |word| word.length == 5 }==a.any? { |word| word.length == 5 } #=> true #=> true
p a.my_any? { |word| word.length >= 4 } ==a.any? { |word| word.length >= 4 } #=> false#=> false
p a.my_any?(/d/)                       ==a.any?(/d/)                        #=> true #=> true
p [1, 3.14, 42].my_any?(Float)                         ==[1, 3.14, 42].any?(Float)                         #=> false#=> false
p [].my_any?                                          ==[].any?                                           #=> true #=> true
p [nil].my_any?                                       ==[nil].any?                                        #=> true #=> true

p [nil, false].my_any?                                ==[nil, false].any?                                 #=> true #=> true
b = [nil, false, 'ad']
p b.my_any?                       ==b.any?                       #=> false#=> false
p eval("b.my_"+word)

ary = [1, 2, 4, 2]
p ary.my_count            #=> 2
p [1, 3.14, 42].my_map { |i| i*i }      #=> [1, 4, 9, 16]
p [1, 3.14, 42].to_a