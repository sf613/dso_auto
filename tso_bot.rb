require 'java'
require 'rubygems'
require 'sikuli_automated'
require 'builder'
class TsoBot
  attr_accessor :sikuli_executor, :input_data_path
  
  def initialize(variant)
    @sikuli_executor = SikuliAutomated.new(variant)
    @input_data_path = File.dirname(File.expand_path($0))
  end
  
  def handle_marmor_find
    @sikuli_executor.find_all_resource("marmor", 7)
  end
  
  def handle_iron_find
    @sikuli_executor.find_all_resource("eisen", 14)
  end
  
  def handle_gold_find
    @sikuli_executor.find_all_resource("gold", 8)
  end
  def read_coords_from_file(filepath)
    @contents = CSV.new(filepath)
    @coords = @contents.to_a
  end
  def buff_all_bakeries
    coords = read_coords_from_file("#{this.input_data_path}/input/bakeries.csv")
    @sikuli_executor.buff_building_group(coords)
  end   
end


instance = TsoBot.new("work")
instance.handle_marmor_find   #tested at work, working fine