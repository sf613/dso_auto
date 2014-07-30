require 'testclass1'

class Test2 < Test
  def initialize
    @dupa = "1234"
  end
end

Test2.new.print