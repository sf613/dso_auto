
class Testclass 
    #attr_accessor :count
    
    def initialize
      #@count = 10
    end    
  def decrement
    puts "===================="
    puts "a before = #{@count}"
    @count += 1
    puts "a after = #{@count}"
  end

  def do_whatever(cnt)
    @count = cnt                         #example : trick polega na tym, ze @count musi byc zarejestrowany w instancji i wtedy mozna go dekrementowac, ale musi byc referowany bezposrednio a nie przekazywany przez argument metody
    puts "initial count is #{@count}"
    5.times {|i|
       decrement
    }
  end
end 
instance = Testclass.new
instance.do_whatever(7)
