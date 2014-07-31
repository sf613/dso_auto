require 'abstractbot'
class MainBot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
 def initialize(variant)
    super
 end

end  #end of class

instance = MainBot.new("work")
instance.buff_all_goldmines
instance.buff_min_goldsmelters
instance.buff_all_goldtowers

