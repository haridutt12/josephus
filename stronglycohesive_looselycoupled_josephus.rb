require 'thread'
require 'java'
# require 'pry'
class Game
  def initialize
    raise NotImplementedError
  end

  def start
    raise NotImplementedError
  end
end

def process_game(game_obj)
  game_obj.start
end


class Josephus < Game
  attr_accessor :ring, :size, :k, :swords
  def initialize(size, k, swords)
    @size = size
    @k = k
    @num_swords = swords.length
    @ring = Ring.new(size, swords)
    @mutex = Mutex.new
    @threads = []
   end

  def start
    @num_swords.times do |sword|
      done = false
      @threads << Thread.new {
        until done
          @mutex.synchronize  do
            break if done
            holder = @ring.sword_holder(sword+1)

            candidate = @ring.candidate(@k, sword+1)
            if holder == candidate
              done = true
              break
            end

            holder.kill(candidate)

            candidate = @ring.candidate(@k, sword+1)
            if holder == candidate
              done = true
              break
            end

            holder.pass(candidate)
          end
        end
      }
    end

    wait
    output
  end

  def wait
  @threads.each(&:join)
  end

  def output
    puts "last man standing #{@ring.all_alive}"
  end

end
class Ring
  attr_reader :ring

  def initialize(size, swords)
    @ring = []
    size.times do |i|
      @ring << Person.new(i)
    end

    swords.each.with_index(1) do |sword_position, sword_name|
      @ring[sword_position].has_sword = sword_name
    end
  end

  def num_alive
    count = 0
    @ring.each { |p| count += 1 if p.is_alive }
    count
  end

  def sword_holder(name)
    @ring.find { |p| p.has_sword == name }
  end

  def candidate(k, sword_name)
    sword_holder_index = @ring.find_index(sword_holder(sword_name))
    num = 0
    index = sword_holder_index
    while num < k
      index = (index + 1) % @ring.length
      num += 1 if @ring[index].is_alive && @ring[index].has_sword == 0

      break if index == sword_holder_index
    end
    # $stderr.puts "sword_holder = #{sword_holder_index}, candidate = #{index}"
    @ring[index]
  end

  def all_alive
    alive = @ring.select { |p| p.is_alive == true }
    alive.map { |p| @ring.find_index(p) }
  end
end

class Person
  attr_accessor :is_alive, :has_sword, :name

  def initialize(name)
    @is_alive = true
    @has_sword = 0
    @name = name
  end

  def kill(person)
    person.is_alive = false
    p "#{@name} killed #{person.name}"
  end

  def pass(person)
    person.has_sword = @has_sword
    @has_sword = 0
  end
end

if __FILE__== $0
puts "enter no of person , steps , swords"
p = gets.to_i
s = gets.to_i
sw = gets.to_i
puts " enter the index on which u wanna place sword"
swords = []
sw.to_i.times do |i|
  swords[i] = gets.to_i
end

process_game(Josephus.new(p, s, swords))
end
