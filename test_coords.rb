require 'java'
require 'rubygems'
require 'sikuli-script.jar'
require 'convenience'
require 'csv'

java_import 'org.sikuli.script.Region'
java_import 'org.sikuli.script.Screen'
java_import 'org.sikuli.script.Finder'
java_import 'org.sikuli.script.Match'
java_import 'org.sikuli.script.Key'
java_import 'org.sikuli.script.Pattern2'
java_import 'org.sikuli.script.Location'
java_import 'org.sikuli.script.Settings'
java_import 'org.sikuli.script.SikuliEvent'
java_import 'org.sikuli.script.SikuliScript'
class TestCoords
  attr_accessor :screen, :sikuli, :image_path, :count, :variant, :user
  def initialize(variant,user, browser)
    @browser = browser
    @screen = Screen.new
    @sikuli = SikuliScript.new
    @user = user
    @image_path = File.dirname(File.expand_path($0))+"/res"
    #@action_count = action_count
    @variant = variant
    if @variant == "home"
      @star_menu_region = Region.new(480,270,400,260)
      @csv_path = @image_path+"/xyHome/#{user}"
    elsif @variant == "work"
      @star_menu_region = Region.new(760,560,400,280)
      @csv_path = @image_path+"/xyWork/#{user}"
    end
  end

  def star_menu
    @screen.click(@screen.find("#{self.image_path}/star.png"))
  end


  def buff_building(coord)
    star_menu
    if object_exists?("#{self.image_path}/basket.png", 0.8) != 1
      @screen.click(@screen.find("#{self.image_path}/l_specialisten.png"))
      @screen.click(@screen.find("#{self.image_path}/l_buffs.png"))
      scroll_to_baskets
    end
    @screen.click(@screen.find("#{self.image_path}/basket.png"))
    @screen.double_click(coord)
    if object_exists?("#{self.image_path}/b_cancel.png", 0.8) == 1
      @screen.click(@screen.find("#{self.image_path}/b_cancel.png"))
    end
  end

  def move_cursor_around(scroll=nil, type=nil)
  	@sikuli.switch_app(@browser)
    begin
   	  @coords = CSV.read("#{@csv_path}/#{type}.csv")
   	  coords_array = @coords
      @unique_sector_numbers = []
      coords_array.each do |row|
        @unique_sector_numbers << row[0].to_i
      end
      @unique_sector_numbers.uniq!
      @unique_sector_numbers.each do |sector|
        Convenience.jump_to_sector(sector, @image_path, @screen)
        
        puts "#{sector.class}, #{scroll.class} , #{type.class}"
        #perform scrolling the view if necessary

        if sector == 2 && scroll && type == "goldsmelters"
          puts "sector = 2, scrolling to view the smelters "
          Convenience.drag_to_location(Location.new(608,184), Location.new(608,378), @screen)
          
        end
        if sector == 1 && scroll && type == "copper_smelters"
          puts "sector = 1, scrolling to view the smelters "
          Convenience.drag_to_location(Location.new(618,390), Location.new(402,543), @screen)
        end
        if sector == 3 && scroll && type == "ironmines"
          puts "sector = 3, scrolling to view the mines "
          Convenience.drag_to_location(Location.new(711,247), Location.new(711,404),@screen)
        end
        if sector == 5 && scroll && type == "ironmines"
          puts "sector = 5, scrolling to view the smelters "
          Convenience.drag_to_location(Location.new(594,283), Location.new(1047,553), @screen)
        end                      
        coords_array.each do |row|    #buff only buildings in sector X           #REFACTORED, WORKING
          if row[0].to_i == sector
            @screen.mouse_move(Location.new(row[1].to_i, row[2].to_i))
            sleep(0.5)
          end

        end

      end
    rescue => e
      puts e
    end
  end
end
#  initialize(variant,user, browser)
instance = TestCoords.new(ARGV[0],"main",ARGV[1])
#  move_cursor_around(scroll=nil, type=nil)
instance.move_cursor_around(ARGV[3],ARGV[2])

