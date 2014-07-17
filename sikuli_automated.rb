require 'java'
require 'rubygems'

require 'sikuli-script.jar'
java_import 'org.sikuli.script.Region'
java_import 'org.sikuli.script.Screen'
java_import 'org.sikuli.script.Finder'
java_import 'org.sikuli.script.Match'
java_import 'org.sikuli.script.Key'
java_import 'org.sikuli.script.Pattern'
java_import 'org.sikuli.script.Location'
java_import 'org.sikuli.script.Settings'
java_import 'org.sikuli.script.SikuliEvent'
java_import 'org.sikuli.script.SikuliScript'

class SikuliAutomated 
    attr_accessor :screen, :sikuli, :image_path, :count, :variant
    
    def initialize(variant)
      @screen = Screen.new
      @sikuli = SikuliScript.new
      @image_path = File.dirname(File.expand_path($0))+"/res"
      #@action_count = action_count
      @variant = variant
      if @variant == "home"
        @star_menu_region = Region.new(480,270,400,260) 
        @csv_path = @image_path+"/xyHome"
      elsif @variant == "work"
        @star_menu_region = Region.new(760,560,400,280) 
        @csv_path = @image_path+"/xyWork" 
      end
    end
    
    def star_menu
      @screen.click(@screen.find("#{self.image_path}/star.png"))
    end
    
	def object_exists?(object, tolerance)  #wrapper dziala cudownie
		begin
      pattern = Pattern.new(object).similar(tolerance)
      match = @screen.find(pattern)
      sleep(2)
			puts "object lookup successful for tolerance #{tolerance}"
			return 1
		rescue => e
			puts e
			return 0
		end			
	end
	
	def scroll_to_geo
	 @limiter = 0
		while object_exists?("#{self.image_path}/geo.png", 0.85) != 1 && @limiter < 6 do           
			puts 'no geo visible on screen, scrolling down .. '               
			@screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
			sleep(1)
			@limiter +=1
		end	
	end	
	
	 def scroll_to_baskets  #refactor
    while object_exists?("#{self.image_path}/basket.png", 0.8) != 1 do
      puts 'no baskets visible on screen, scrolling down .. '                
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
      sleep(0.5)
    end 
  end 
 def send_geo_for(resource, geo)
	puts 'sending geo .. '
    @screen.click(geo)
	puts 'choosing resource .. '
    @screen.click(@screen.find("#{self.image_path}/r_#{resource}.png")) 
    @screen.click(@screen.find("#{self.image_path}/ok_button.png")) 
  end
    
  def send_geo?(resource,geo)  #convenience
    if @count > 0           
      send_geo_for(resource,geo)
      @count -= 1
      star_menu
    else 
      puts "no actions for geo #{geo}, maximum count of searches reached" 
      star_menu
    end
  end  
   
  def find_all_resource(resource, count)
    @count = count 
    @sikuli.switch_app("Chrome")
    star_menu 
    if object_exists?("#{self.image_path}/geo.png", 0.8) != 1
      @screen.click(@screen.find("#{self.image_path}/l_buffs.png"))  
      @screen.click(@screen.find("#{self.image_path}/l_specialisten.png"))
      scroll_to_geo
    end
	  puts "repetitions to do : #{count}"	 
    @geo_row  = @screen.find_all(Pattern.new("#{self.image_path}/geo.png").similar(0.8))  
    @geo_row.each do |geo|
      send_geo?(resource,geo)   # @count decrements
    end  
    if @count > 0 
      puts "first row clean, scrolling to next one; left to send : #{@count}"
    end
    while @count > 0 
       puts "inside the while loop; count : #{@count}"
       region = @star_menu_region  
       @screen.click(region.find(Pattern.new("#{self.image_path}/b_scrollDown.png").similar(0.85)))      
       @geo_next_row  = region.find_all(Pattern.new("#{self.image_path}/geo.png").similar(0.85))  
       @geo_next_row.each do |geo|
         puts "from inside geo next row; count : #{count}"
         send_geo?(resource,geo)
       end
    end          
  end

  def buff_building(coord)  
    star_menu
    if object_exists?("#{self.image_path}/basket.png", 0.8) != 1 
      @screen.click(@screen.find("#{self.image_path}/l_specialisten.png"))  #soft reset okna, jesli nie widac na ekranie buffow to trudno stwierdzic czy scroll jest powyzej czy ponizej, wiec lepiej zresetowac
      @screen.click(@screen.find("#{self.image_path}/l_buffs.png")) 
      scroll_to_baskets
    end
    @screen.click(@screen.find("#{self.image_path}/basket.png"))    #zalozenie, ze przy kilku koszykach w polu widzenia wybierze dowolny, a przy jednym - jedyny - wiec nie trzeba kombinowac z iterowaniem albo wybieraniem elementu z kolekcji 
    @screen.double_click(coord)  
    #check_for_cancel_button   # chyba pozostalosc po jakiejs innej metodzie albo blad przy kopiownaiu. 
     if object_exists?("#{self.image_path}/b_cancel.png") == 1
       @screen.click(@screen.find("#{self.image_path}/b_cancel.png"))
     end   
  end
  
  def buff_building_group(coords_file)
    @unique_sector_numbers = []
    CSV.foreach(coords_file) do |row|
       @unique_sector_numbers << row[0]
    end
    @unique_sector_numbers.uniq!       
    @unique_sector_numbers.each do |sector|   
      @sector_key = case sector
        when 1 then Key.NUM1         # zweryfikowac czy typy sa poprawne i nie dzieja sie cuda przy porownywaniu stringow i intow
        when 2 then Key.NUM2 
        when 3 then Key.NUM3
        when 4 then Key.NUM4
        when 5 then Key.NUM5
        when 6 then Key.NUM6 
        when 7 then Key.NUM7        
        when 8 then Key.NUM8       
        when 9 then Key.NUM9                       
      end 
      @sikuli.type(@sector_key)   # jump to sector X
      CSV.foreach(coords_file) do |row|      #buff only buildings in sector X
        if row[0] == sector
          sleep(0.5)
          location = new Location(row[1], row[2])
          buff_building(location)
        end
      end       
    end  
  end
  
  def scroll_to_explorer
    @limiter = 0
    while object_exists?("#{self.image_path}/explorer.png") != 1 && @limiter < 7 do           
      puts 'no geo visible on screen, scrolling down .. '                
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
      sleep(1)
      @limiter +=1
      puts @limiter
    end 
  end
  def send_explorer_for_treasure(explorer, length)  
    @screen.click(explorer)
    @screen.click(@screen.find("#{self.image_path}/find_treasure.png")) 
    case length
      when "short" then @screen.click(@screen.find("#{self.image_path}/treasue_short.png"))    
      when "medium" then @screen.click(@screen.find("#{self.image_path}/treasure_medium.png"))
      when "long" then @screen.click(@screen.find("#{self.image_path}/treasure_long.png"))
      when "longest" then @screen.click(@screen.find("#{self.image_path}/treasure_longest.png"))
    end  
    @screen.click(@screen.find("#{self.image_path}/ok_button.png"))
  end  
  def find_treasure(length)    
    star_menu
    scroll_to_explorer
    4.times {|i| 
      region = @star_menu_region  
      matches = region.find_all(Pattern.new("#{self.image_path}/explorer.png").similar(0.8))
      matches.each do |explorer|
        send_explorer_for_treasure(explorer, length)
        star_menu    
      end  
      matches = region.find_all(Pattern.new("#{self.image_path}/explorer2.png").similar(0.8))
      matches.each do |explorer|
        send_explorer_for_treasure(explorer, length)
        star_menu    
      end  
      matches = region.find_all(Pattern.new("#{self.image_path}/explorer3.png").similar(0.8))
      matches.each do |explorer|
        send_explorer_for_treasure(explorer, length)
        star_menu    
      end 
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
    } 
  end
end 

