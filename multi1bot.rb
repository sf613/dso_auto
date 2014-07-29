require 'abstractbot'
class Multi1bot < AbstractBot
  attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
  
  def initialize(variant)
    @browser = "FireFox"
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
  
    def switch_to_main
    begin
      @sikuli.switch_app(@browser)
      @screen.click(@screen.find(Pattern.new("#{@sikuli_executor.image_path}/switch_portrait.png").similar(0.8)))
      sleep(1)
      @screen.click(@screen.find("#{@sikuli_executor.image_path}/besuchen.png"))
      @screen.wait("#{@sikuli_executor.image_path}/city_centre.png", 40)
    rescue  
    end
  end
end
  