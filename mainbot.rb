require 'abstractbot'
class MainBot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
 def initialize(variant)
    super
 end

end  #end of class

instance = MainBot.new("work")
p instance
instance.buff_all_bows
#instance.handle_marmor_find   #tested at work, working fine
