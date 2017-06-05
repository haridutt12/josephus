class Person
	#attr_accessor :is_alive

	def initialize
		@is_alive=true
	end

	def is_alive
		return @is_alive
	end

	def is_alive=(val)
		@is_alive = val
	end
end

class Game
	def initialize(n)
		@ring = []
		@has_sword=0
		@is_on = false
		n.times do
		    @ring << Person.new
		end
	end
	
	def stop
        @is_on = false
        p "Last man stading =", @has_sword
    end

	def kill
		flag = (@has_sword+1)% @ring.length
        until @ring[flag].is_alive do
        	flag=(flag+1)% @ring.length 
        end
        @ring[flag].is_alive = false
        p "#{flag} died"
    end

    def pass
    	flag = (@has_sword+1)% @ring.length
    	while not @ring[flag].is_alive do
        	flag=(flag+1)% @ring.length 
        end

        if flag == @has_sword
            stop
        else
            @has_sword = flag
            puts "#{@has_sword} has the sword"
        end
    end
    def start
    	@is_on = true
        print "0 has the sword"
        while @is_on do
            kill()
            pass()
        end
    end

    def ring
    	@ring
    end

    def is_on
    	@is_on
    end

    def is_on=(val)
    	@is_on = val
	end

    def has_sword
    	@has_sword
    end
  
end

if __FILE__== $0
	game = Game.new(ARGV[0].to_i)
	game.start()
end
