require 'testfile'

class NewClass
  def initialize  
  end
  
  def make_use_of_other_shit
    Testclass.new.do_whatever(7)
  end
end
