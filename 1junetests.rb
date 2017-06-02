require 'minitest/autorun'
require_relative '1june'

 class TestPerson < Minitest::Test

   def setup
     @person = Person.new
   end

   def test_initialize
     assert_equal true, @person.is_alive
   end
 end

class TestGame < Minitest::Test
  def setup
  	@num = 6 # make this random
  	@game = Game.new(@num)
  	p @game.has_sword
  	@game.kill
  end

  def test_inital_state
  	assert_equal @game.ring.length, @num
  	assert_equal @game.has_sword, 0
  	assert_equal @game.is_on, false

  end

  # def test_stop
  # 	assert_equal @game.is_on, false
  # end
 
  def test_kill

  	# Get the state (which will be changed) before the behaviour call
  	alive_count = 0
  	@game.ring.each { |p| alive_count += 1 if p.is_alive }
  	# @game = Game.new(@num)
  	@game.kill

  	# check the state after the call
  	new_alive_count = 0
  	@game.ring.each { |p| new_alive_count += 1 if p.is_alive }
  	assert_equal new_alive_count, alive_count - 1
  end


   def test_pass
   	sword = @game.has_sword
   	@game.pass
   	sword_2 = @game.has_sword
   	assert_equal sword , sword_2 - 2
   end

   def test_start
       # assert_equal @game.is_on, true
        @game.start
        assert_equal @game.is_on, false
   end

   def test_stop
   		@game.is_on = true
   	    @game.stop
   	    assert_equal @game.is_on, false
   end



  # def test_stop
  #   assert_equal false , @game.is_on  	
  # end

end