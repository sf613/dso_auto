require 'abstractbot'
class Multi1bot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
  def initialize(variant)
    @browser = "FireFox"
    @user = "multi1"
    @screen = Screen.new
    @sikuli = SikuliScript.new
    @sikuli_executor = Executor.new(variant,"multi1", @browser)
    @image_path = File.dirname(File.expand_path($0))+"/res"
    @variant = variant
      if @variant == "home"
        @star_menu_region = Region.new(480,270,400,260) 
        @csv_path = @image_path+"/xyHome/multi1"
      elsif @variant == "work"
        @star_menu_region = Region.new(760,560,400,280) 
        @csv_path = @image_path+"/xyWork/multi1" 
      end
  end
 
  def buff_main_bakeries
    @csv_path = @image_path+"/xyWork/main"

    buff_all_bakeries
  end 
    
  def buff_main_bows
    @csv_path = @image_path+"/xyWork/main"
    buff_all_bows 
  end 
    
  def buff_main_bronzeswords
    @csv_path = @image_path+"/xyWork/main"
    buff_all_bronzeswords
  end 
    
  def buff_main_copper_smelters
    @csv_path = @image_path+"/xyWork/main"
    buff_all_copper_smelters
  end
  
  def buff_main_goldtowers
    @csv_path = @image_path+"/xyWork/main"
    buff_all_goldtowers
  end 
  
  def buff_main_goldsmelters
    @csv_path = @image_path+"/xyWork/main"
    buff_all_goldsmelters
  end 
  
  def buff_main_goldsmelters_min
    @csv_path = @image_path+"/xyWork/main"
    buff_min_goldsmelters
  end 
  
  def buff_main_coinmakers
    @csv_path = @image_path+"/xyWork/main"
    buff_all_coinmakers
  end 
  
  def buff_main_coinmakers_min
    @csv_path = @image_path+"/xyWork/main"
    buff_min_coinmakers
  end 
end #of class

instance = Multi1bot.new("work")
instance.rebuild_fields
  