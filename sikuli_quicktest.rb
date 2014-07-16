require 'java'
require 'rubygems'
require 'csv'

$CLASSPATH << "D:\sikuli"
$JAVA_HOME = "C:\Program Files (x86)\Java\jre6" 
# jar przeniesiony do katalogu z projektem zeby uniknac jebania sie z classpathem
#
require 'sikuli-script.jar'
java_import 'org.sikuli.script.Region'
java_import 'org.sikuli.script.Button'
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
    attr_accessor :screen, :sikuli, :image_path
    
    def initialize
      @screen = Screen.new
      @sikuli = SikuliScript.new
      @image_path = File.dirname(File.expand_path($0))+"/res"
    end
    
    def star_menu
      @sikuli.switch_app("Chrome")
      @screen.click(@screen.find("#{self.image_path}/star.png"))
	  #@screen.find_all("#{self.image_path}/star.png").each do |result|  # zupelnie zbedne, ale moze zostac jako example
	  # @screen.click(result)	
	  #end
    end

	def click_on_geo
	     region = Region.new(740,510,500,400)      # x,y,w,h   pierwsze dwa to coordy lewego gornego wierzcholka, pozostale to wymiary regionu; osie jak na normalnym ukladzie wspolrzednych tylko oY idzie w dol - lewy gorny rog ekranu to (0,0)
    	 matches = region.find_all("#{self.image_path}/geo.png")
    	 @c = 0
    	 matches.each do |match|
    	   @c+=1
    	 end  
    	 puts @c
	end  
	
	 def method_sample_find_all_geos_in_region
	     @sikuli.switch_app("Chrome") 
       region = Region.new(490,280,500,400)      # x,y,w,h   pierwsze dwa to coordy lewego gornego wierzcholka, pozostale to wymiary regionu; osie jak na normalnym ukladzie wspolrzednych tylko oY idzie w dol - lewy gorny rog ekranu to (0,0)
       matches = region.find_all("#{self.image_path}/geo.png")
       @c = 0
       matches.each do |match|
         @c+=1
       end  
       puts @c
  end 
  
  def method_sample_star_menu_scroll_button
        @sikuli.switch_app("Chrome") 
       region = Region.new(1050,720,90,90)      # x,y,w,h   pierwsze dwa to coordy lewego gornego wierzcholka, pozostale to wymiary regionu; osie jak na normalnym ukladzie wspolrzednych tylko oY idzie w dol - lewy gorny rog ekranu to (0,0)
       matches = region.find_all("#{self.image_path}/b_scrollDown.png")
       @c = 0
       matches.each do |match|
         @c+=1
       end  
       puts @c
  end
  def scroll_to_geo
  # while not @screen.exists("#{self.image_path}/geo.png") do
   @limiter = 0
    while object_exists? != 1 && @limiter < 6 do           #BUG : finder lapie portret geologa w gornym lewym rogu na wiadomosci o wyslaniu; zaimplementowac find_in_region
      puts 'no geo visible on screen, scrolling down .. '                #BUG : exists najwyrazniej nie odroznia wyszarzonego geo od zwyklego
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
      sleep(1)
      @limiter +=1
      puts @limiter
    end 
  end 	
  
  def click_on_empty_fields   #convienience method do testowania coordow klikalnych obiektow
    @sikuli.switch_app("Chrome") 
    matches = @screen.find_all("#{self.image_path}/empty_field.png")
    matches.each do |object|
     # @screen.click(object)  
     puts object.get_center.get_x  
    end  
  end
  
  def dump_object_coords(type, sector, tolerance)  
    @sikuli.switch_app("Chrome") 
    matches = @screen.find_all(Pattern.new("#{self.image_path}/#{type}.png").similar(tolerance))
    File.open("#{self.image_path}/#{type}.csv", "a") {|f| 
      matches.each do |object|
        f.puts "#{sector.to_s},#{object.get_center.get_x},#{object.get_center.get_y}" 
      end
    }   
  #        puts "#{sector.to_s},#{object.get_center.get_x},#{object.get_center.get_y}" 
  end
  def object_test 
    begin
      object = "#{self.image_path}/basket.png"
      pattern = Pattern.new(object).similar(0.65)
      match = @screen.find_all(pattern)
      c = 0
      match.each do |element|
        c +=1
      end
      puts "count is #{c}"
      return 1
    rescue => e
      puts e
      puts 'exception catched from: object not found'
      return 0
    end 
  end
  
  def click_na_budynek
    @sikuli.switch_app("Chrome")
           region = Region.new(480,270,400,260)  
       @screen.click(region.find("#{self.image_path}/b_scrollDown.png"))
=begin    region = Region.new(920,615,25,25)
    sleep(1)
    location = Location.new(933, 623)
    result = @screen.click(region)
    puts result
    puts @screen.last_match
=end 
 
  #@screen.double_click(@screen.find("#{self.image_path}/drwal.png"))  #BUG : double click jest jedyna dzialajaca mozliwoscia klikniecia na budynek na glownym obszarze !!!ö
  end

    def object_exists
          @sikuli.switch_app("Chrome")
    object = "#{self.image_path}/geo.png"
    tolerance = 0.85
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
  
    def move_cursor_to_location
       @sikuli.switch_app("Chrome") 
       region = Region.new(480,270,400,260)   
       region.mouse_move(region.find("#{self.image_path}/b_scrollDown.png"))      
    end
end  #of class

instance = SikuliAutomated.new
#instance.star_menu
#instance.dump_object_coords("goldmine_temp", 2, 0.8)
#instance.click_na_budynek
instance.object_test