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
    temparr
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |temp| return false if yield(temp) == false }

    elsif !arg.nil?
      my_each { |temp| return false if temp != arg }

    end
    true
  end

  def my_any?(args = nil)
    if block_given?
      my_each { |temp| return true if yield(temp) == true }

    elsif !args.nil?
      my_each { |temp| return true if temp == args }

    end
    false
  end

  def my_none?(args = nil)
    if block_given?
      my_each { |temp| return false if yield(temp) == true }

    elsif !args.nil?
      my_each { |temp| return false if temp == args }

    end
    true
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
puts [1, 2, 3, 4, 5].my_select(&:even?)

puts '***my_all method***'
puts(%w[ant bear cat].my_all? { |x| x.length >= 3 })
puts(%w[ant bear cat].my_all? { |x| x.length >= 4 })
puts arr.my_all?(3)
puts [].my_all?

puts '***my_any method***'
puts(%w[ant bear cat].my_any? { |x| x.length >= 3 })
puts(%w[ant bear cat].my_any? { |x| x.length >= 4 })
puts [1, 3, 2, 6].my_any?(8)
puts [].my_any?

puts '***my_none method***'
puts(%w[cat bat house].my_none? { |x| x == 'rat' })
puts(%w[cat bat house].my_none? { |x| x == 'house' })

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
