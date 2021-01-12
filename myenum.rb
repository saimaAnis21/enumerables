module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
     
    arr=to_a
     i = 0
    loop do
      yield(arr.to_a[i])
      i += 1
      break if i== arr.to_a.length
    end
    
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |item|
      yield(item,i)
      i+=1
    end
    
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    temparr = []

    my_each do |temp|
      temparr.push(temp) if yield(temp) == true
    end
    return temparr
  end

  def my_all?(arg = nil)
    return true if empty?
    if block_given? && arg.nil?
      my_each { |temp| return false if yield(temp) == false }
       true
    elsif  arg.nil? && !block_given?
        my_each {|temp| return false if temp.nil? || temp==false}
        true
    elsif !arg.nil? && arg.instance_of?(Regexp) 
      my_each {|temp| return false if !temp.match(arg)}
      true
    elsif !arg.nil? && (arg.is_a? Class)
      my_each {|temp| return false if !(temp.class == arg || temp.class.superclass== arg )}
      true
    else
      my_each { |temp| return false if temp != arg }
      true
    end
  
  end

  def my_any?(arg = nil)
    return false if empty?

    if block_given? && arg.nil?
      my_each { |temp| return true if yield(temp) == true }
       false
    elsif  arg.nil? && !block_given?
        my_each {|temp| return true if temp}
        false
    elsif !arg.nil? && arg.instance_of?(Regexp) 
      my_each {|temp| return true if temp.match(arg)}
      false
    elsif !arg.nil? && (arg.is_a? Class)
      my_each {|temp| return true if (temp.class == arg || temp.class.superclass== arg )}
      false
    else
      my_each { |temp| return true if temp == arg }
      false
    end
end

def my_none?(arg = nil)
  return true if empty?
  if block_given? && arg.nil?
    my_each { |temp| return false if yield(temp) == true }
     true
  elsif  arg.nil? && !block_given?
      my_each {|temp| return false if temp}
      true
  elsif !arg.nil? && arg.instance_of?(Regexp) 
    my_each {|temp| return false if temp.match(arg)}
    true
  elsif !arg.nil? && (arg.is_a? Class)
    my_each {|temp| return false if (temp.class == arg || temp.class.superclass== arg )}
    true
  else
    my_each { |temp| return false if temp == arg }
    true
  end
end

  def my_count(args = nil)
    count = 0
    if block_given?
      my_each do |temp|
        count += 1 if yield(temp) == true
      end
      count

    elsif !args.nil?
      my_each do |temp|
        count += 1 if temp == args
      end
      count

    else
      count = length
    end
  end

  def my_map(myproc = nil)
    return to_enum(:my_map) unless block_given? || !myproc.nil?

    i = 0
    temparr = []
    if myproc.nil?
      my_each do |temp|
        temparr[i] = yield(temp)
        i += 1
      end
    else
      my_each do |y|
        temparr[i] = myproc.call(y)
        i += 1
      end
    end
    temparr
  end
end

def multiply_els(arr2)
  arr2.my_inject { |x, y| x + y }
end

arr = [1, 2, 3]

# multiply_els(arr)

puts '***my_each method***'
[1,4,6,3,4].my_each { |x| puts x }
%w[ant bear cat].my_each { |x| puts x }


puts '***my_each_with_index  method***'
arr.my_each_with_index { |x, y| puts x if y.even? }

puts '***my_select method***'
puts [1, 2, 3, 4, 5].my_select {|x| x<=3}
puts [1, 2, 3, 4, 5].my_select {|x| x%2==0}

puts '***my_all method***'
puts(%w[ant bear cat].my_all? { |x| x.length >= 3 })
puts(%w[ant bear cat].my_all? { |x| x.length >= 4 })
puts [0,1,2].my_all?{|x| x<3}
puts [0,1,2].my_all?{|x| x<2}
puts [3,3,3].my_all?(3)
puts [].my_all?
puts [0,nil,2].my_all?
puts [0,false,2].my_all?
puts %w[food fool foot].my_all?(/foo/)
puts [1,2,3].my_all?(Numeric)

puts '***my_any method***'
puts(%w[ant bear cat].my_any? { |x| x.length == 4 })
puts(%w[ant bear cat].my_any? { |x| x.length >= 5 })
puts [1, 3, 2, 6].my_any?(6)
puts [].my_any?
puts [nil,0,false].my_any?
puts [nil,false].my_any?
puts(%w[food drink].my_any?(/foo/))
puts(%w[food drink].my_any?(/bar/))

puts '***my_none method***'
puts(%w[cat bat house].my_none? { |x| x == 'rat' })
puts(%w[cat bat house].my_none? { |x| x == 'house' })
puts(%w[cat bat house].my_none?(/d/))
puts [].my_none?
puts [nil].my_none?
puts [nil,false].my_none?
puts [nil,false,true].my_none?
puts [1,3.14,42].my_none?(Float)

ary = [1, 2, 4, 2]
puts '***my_count method***'
puts ary.my_count
puts ary.my_count(2)
puts ary.my_count(&:even?)

puts '***my_map method***'

myorder = ['medium Big Mac', 'medium fries', 'medium milkshake']
puts(myorder.my_map { |item| item.gsub('medium', 'extra large') })
puts([1, 2, 3, 4, 5].my_map { |a| a * a })

puts '***my_map method with proc***'
myproc = proc { |x| x * x }
puts arr.my_map(myproc)

# puts '***my_inject method***'
# puts [1, 2, 3, 4, 5].my_inject { |x, y| x + y }
# puts [1, 2, 3, 4, 5].my_inject { |x, y| x + y }
