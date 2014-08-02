require 'abstractbot'
class MainBot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
 def initialize(variant)
    super
 end

end  #end of class

instance = MainBot.new("home")
instance.buff_min_goldsmelters


