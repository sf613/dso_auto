require 'java'
require 'rubygems'
require 'csv'
require 'sikuli'

# jar przeniesiony do katalogu z projektem zeby uniknac jebania sie z classpathem
#
require 'sikuli-script.jar'
require 'convenience'
java_import 'org.sikuli.script.Region'
java_import 'org.sikuli.script.Button'
java_import 'org.sikuli.script.Screen'
java_import 'org.sikuli.script.Finder'
java_import 'org.sikuli.script.Match'
java_import 'org.sikuli.script.Key'
java_import 'org.sikuli.script.KeyModifier'
java_import 'org.sikuli.script.KeyCodeConverter'
java_import 'org.sikuli.script.Pattern'
java_import 'org.sikuli.script.Location'
java_import 'org.sikuli.script.Settings'
java_import 'org.sikuli.script.SikuliEvent'
java_import 'org.sikuli.script.SikuliScript'


class UnitTesting 
    attr_accessor :screen, :sikuli, :image_path
    
    def initialize
      @screen = Screen.new
      @sikuli = SikuliScript.new
      @image_path = File.dirname(File.expand_path($0))+"/res"
      @csv_path = @image_path+"/xyHome/main"
      @variant = "home"
    end
    
    def star_menu
      @sikuli.switch_app("Chrome")
      @screen.click(@screen.find("#{self.image_path}/star.png"))
	  #@screen.find_all("#{self.image_path}/star.png").each do |result|  # zupelnie zbedne, ale moze zostac jako example
	  # @screen.click(result)	
	  #end
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
  
  def click_on_empty_fields#convienience method do testowania coordow klikalnych obiektow
    @sikuli.switch_app("Chrome") 
    matches = @screen.find_all("#{self.image_path}/empty_field.png")
    3.times {|i|
      @screen.double_click(matches.next) 
    }
    #matches.each do |object|
     # @screen.click(object)  
     puts object.get_center.get_x  
    #end  
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
    
    def test_coords_from_csv 
     @sikuli.switch_app("Chrome")
    begin 
      @screen.click(@screen.find(Pattern.new("#{self.image_path}/collapse_panel.png").similar(0.85)))
    rescue => e
      puts e  
    end      
    @unique_sector_numbers = []
    @counts = {}
    @csv_hash = {}
    10.times {|i|
      @counts[i] = 0
      @csv_hash[i] = []
      }
     puts "hash before injection : #{@csv_hash}"
     puts "counts before injection : #{@counts}" 
    CSV.foreach(@csv_path+"/goldsmelters_min.csv") do |row|
       @unique_sector_numbers << row[0].to_i
       @csv_hash[row[0].to_i] << [row[1].to_i, row[2].to_i]  #tu powinno byc dopisywanie a nie nadpisywanie
       @counts[row[0].to_i] +=1
    end
    @unique_sector_numbers.uniq!
    @current_queue_size = 0
    @unique_sector_numbers.each do |sector| 
      Convenience.jump_to_sector(sector, @image_path, @screen)
      sleep(0.5)
      if sector == 2
        puts "sector = 2, scrolling to view the smelters "
        Convenience.drag_to_location(Location.new(608,184), Location.new(608,378), @screen)
      end
      @csv_hash[sector].each do |coords| 
         sleep(2)
         loc = Location.new(coords[0].to_i, coords[1].to_i)
         @screen.mouse_move(loc)
      end
     end
   end
   
   def test_iron_mines
    @unique_sector_numbers = []
    @counts = {}
    @csv_hash = {}
    10.times {|i|
      @counts[i] = 0
      @csv_hash[i] = []
      }
     puts "hash before injection : #{@csv_hash}"
     puts "counts before injection : #{@counts}" 
    CSV.foreach(@csv_path+"/build_eisen.csv") do |row|
       @unique_sector_numbers << row[0].to_i
       @csv_hash[row[0].to_i] << [row[1].to_i, row[2].to_i]  #tu powinno byc dopisywanie a nie nadpisywanie
       @counts[row[0].to_i] +=1
    end
    @unique_sector_numbers.uniq!
    @current_queue_size = 0
    @unique_sector_numbers.each do |sector| 
      Convenience.jump_to_sector(sector, @image_path, @screen)
      sleep(0.5)
      @total_to_build = @csv_hash[sector].size
      # @screen.move_to 
      begin
        puts "total number of mines to build : #{@total_to_build} in sector #{sector}" 
        if  @total_to_build < 3
           @csv_hash[sector].each do |coords| 
              if @current_queue_size >=3 
                @current_queue_size = 0
                puts "waiting after 3 repetitions .. "
                sleep(10)
              end
              loc = Location.new(coords[0].to_i, coords[1].to_i)
              @screen.mouse_move(loc)
              @current_queue_size +=1
#              build_building(3, "eisen_mine", loc)
          end
        else 

          @csv_hash[sector].each do |coords|  
              if @current_queue_size >=3 
                @current_queue_size = 0
                puts "waiting after 3 repetitions .. "
                sleep(10)
              end
              loc = Location.new(coords[0], coords[1])
              @screen.mouse_move(loc)
#              build_building(3, "eisen_mine", loc)
              @current_queue_size +=1
              puts "iron mine build on location #{}"
              @total_to_build -=1

              puts "current_queue_size : #{@current_queue_size}"
          end           
        end  
      rescue
      end
    end
   end
   def display
     #@sikuli.switch_app("Chrome")
     #@screen.type(Sikuli::TAB)
     #
     #FIX : kliknac na cos zeby byl focus, wtedy wrzucic type po stringu - np. '4'
     #
     #@screen.type(Location.new(800,600), "6")    #  hack : w kazdym sektorze jest ulepszony magazyn i jest dobrze widoczny, wiec mozna klikac na magazyn zeby zebrac focus i potem zmienic sektor
   end
   def jump_to_sector(number, ref_image_path)
     @screen.type(@screen.find("#{self.image_path}/warehouse_focuspoint.png"), number.to_s)
   end
   
  def switch_to_main
    begin
      @sikuli.switch_app("FireFox")
      @screen.click(@screen.find(Pattern.new("#{self.image_path}/switch_portrait.png").similar(0.8)))
      sleep(1)
      @screen.click(@screen.find("#{self.image_path}/besuchen.png"))
      @screen.wait("#{self.image_path}/city_centre.png", 40)
    rescue => e
      puts e 
    end
  end
end  #of class

instance = UnitTesting.new
#instance.star_menu
#instance.dump_object_coords("goldmine_temp", 2, 0.8)
#instance.click_na_budynek
#instance.click_on_empty_fields
#instance.test_coords_from_csv
#instance.dump_object_coords("kupfer_smelter_h",1,0.6)
#instance.test_iron_mines
instance.test_coords_from_csv