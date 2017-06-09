require 'minitest/autorun'
require_relative 'stronglycohesive_looselycoupled_josephus'
class TestGame < Minitest::Test

	def test_initials
		assert_raises NotImplementedError  do  
		    Game.new  
	    end
    end

end

class TestPerson < Minitest::Test

	def setup
		@name   = 1
		@person = Person.new(@name)
	end

	def test_initialize
	 	assert_equal true, @person.is_alive
	 	assert_equal false, @person.has_sword
	end

	def test_kill
		p = Person.new(1)
		@person.kill(p)
		assert_equal p.is_alive, false
		end

	def test_pass
		p = Person.new(1)
		@person.has_sword = true
		@person.pass(p)
		assert_equal p.has_sword, true
		assert_equal @person.has_sword, false
	end
end

 class TestRing < Minitest::Test

    def setup
    	@size = 10 #make this random
    	@r = Ring.new(@size)	    	
    end

    def test_initialize
    	assert_equal @r.ring.length(), @size
        assert_equal @r.ring.first.has_sword, true
    end

    def test_num_alive
    	count_1 = 0
        @r.ring.each { |p| count_1 += 1 if p.is_alive }
    	@r.ring[1].kill(@r.ring[1])
    	count_2 = 0
        @r.ring.each { |p| count_2 += 1 if p.is_alive }
        assert_equal count_2, count_1-1
    end

    def test_sword_holder
    	holder = @r.sword_holder
    	assert_equal holder.name, 0
    	@r.ring.first.pass(@r.ring.last)
    	holder = @r.sword_holder
    	assert_equal holder.name, @r.ring.length-1
    end

    def next_alive
        assert_equal @r.next_alive(1), 0
        assert_equal @r.next_alive(2), 2
    end

    def test_all_alive
    	r = Ring.new(@size)
    	r.ring.first.kill(r.ring.last)
		assert_equal @size - 1, r.all_alive.length 
		r.ring[3].kill(r.ring[5])
		assert_equal @size - 2, r.all_alive.length
	end
end

class TestJosephus < Minitest::Test
	def setup
		@cases = setup_cases
	end

	def setup_cases
		cases = []
		cases << new_case(10, 1, [4])
		cases << new_case(12, 2, [1, 2])
		cases
	end

	def new_case(size, k, output)
		{
			jo: Josephus.new(size, k),
			out: output
		}
	end

	def test_start
		@cases.each do |c|
			c[:jo].start
			result = c[:jo].ring.all_alive
			assert_equal result.length, c[:out].length
		end
	end
end