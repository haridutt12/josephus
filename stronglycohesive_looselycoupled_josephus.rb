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
  attr_accessor :ring, :size, :k
  def initialize(size, k)
    @size = size
    @k = k
    @ring = Ring.new(size)
  end

  def start
    while @ring.num_alive > @k
      @ring.sword_holder.kill(@ring.next_alive(@k))
      @ring.sword_holder.pass(@ring.next_alive(@k))
    end
    puts "last man standing #{@ring.all_alive}"
  end
end

class Ring
  attr_reader :ring

  def initialize(size)
    @ring = []
    size.times do |i|
      @ring << Person.new(i)
    end
    @ring.first.has_sword = true
  end

  def num_alive
    count = 0
    @ring.each { |p| count += 1 if p.is_alive }
    count
  end

  def sword_holder
    @ring.find { |p| p.has_sword == true }
  end

  def next_alive(k)
    sword_holder_index = @ring.find_index(sword_holder)
    num = 0
    index = sword_holder_index
    while num < k
      index = (index + 1) % @ring.length
      num += 1 if @ring[index].is_alive
    end
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
    @has_sword = false
    @name = name
  end

  def kill(person)
    person.is_alive = false
    p "#{@name} killed #{person.name}"
  end

  def pass(person)
    @has_sword = false
    person.has_sword = true
  end
end

if __FILE__== $0
josephus = Josephus.new(ARGV[0].to_i, ARGV[1].to_i)
josephus.start
game = Game.new()
end