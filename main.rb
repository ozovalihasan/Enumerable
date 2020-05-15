module Enumerable  
  def my_each(&block)
    block_given? ? size.times { |counter| block.call(self[counter]) } : enum_for(__method__)
  end

  def my_each_with_index(&block)
    block_given? ? size.times { |counter| block.call(self[counter], counter) } : enum_for(__method__)
  end

  def my_select
    
  end
  def my_all?
    
  end
  def my_any?
    
  end
  def my_none?

    
  end
  def my_count
    
  end
  def my_map
    
  end

  def my_inject
    
  end

end

#[1, 2, 2].my_each do |item|
#  p item
#end

[8, 2, 6].each_with_index do |item,idx|
  print item, idx
end
p '========='

[8, 2, 6].each do |item|
  p item, '"---------"'
end


[8, 2, 6].my_each do |item|
  p item, '"---------"'
end

p [8, 2, 6].each

p [8, 2, 6].my_each

 [:foo, :bar, :baz].each_with_index do |value, index|
  puts "#{index}: #{value}"
end

 [:foo, :bar, :baz].my_each_with_index do |value, index|
  puts "#{index}: #{value}"
end

p '========='

p [:foo, :bar, :baz].each_with_index 

p [:foo, :bar, :baz].my_each_with_index 



