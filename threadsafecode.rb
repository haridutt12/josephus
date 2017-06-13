require 'thread'

def main()
  a = 0
  threads = []
  mutex = Mutex.new
  5.times do
    t = Thread.new {
      mutex.synchronize do
        temp = a
        sleep(0.5)
        a = temp + 1
        puts a
      end
    }
    threads << t
  end

  threads.each { |t| t.join }
end