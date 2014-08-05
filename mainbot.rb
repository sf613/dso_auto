require 'abstractbot'
class MainBot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
 def initialize(variant)
    super
 end

end  #end of class

instance = MainBot.new(ARGV[0])

instance.composite_action
instance.produce_units
instance.clean_messages



