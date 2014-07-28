require 'java'
require 'rubygems'

require 'sikuli-script.jar'
require 'csv'
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

class BobTheBuilder
  attr_accessor :screen, :sikuli, :image_path, :count, :variant, :user   #nie publikowac jawnie w kodzie nickow userow
    
    def initialize(variant, user)
      @screen = Screen.new
      @sikuli = SikuliScript.new
      @image_path = File.dirname(File.expand_path($0))+"/res"
      #@action_count = action_count
      @variant = variant
      if @variant == "home"
        @star_menu_region = Region.new(480,270,400,260) 
        @csv_path = @image_path+"/xyHome/#{user}"
      #  @building_menu_coords = 
      elsif @variant == "work"
        @star_menu_region = Region.new(760,560,400,280) 
        @csv_path = @image_path+"/xyWork/#{user}" 
        @building_menu_coords = [716,852]
      end
    end
    
  def build_building(category, name, location)
    @screen.click(Location.new(@building_menu_coords[0], @building_menu_coords[1]))  
    case category
      when 1 then @screen.click(@screen.find("#{self.image_path}/building_cat1.png"))  
      when 2 then @screen.click(@screen.find("#{self.image_path}/building_cat2.png"))
      when 3 then @screen.click(@screen.find("#{self.image_path}/building_cat3.png"))
      when 4 then @screen.click(@screen.find("#{self.image_path}/building_cat4.png"))
    end
    @screen.click(@screen.find("#{self.image_path}/b_#{name}.png")) 
    @screen.double_click(location) 
  end 
  def scroll_view_from_sector_center
    #do stuff
    # wykorzystac @screen.drag_and_drop, zestawy koordynatow dla home/ work i dla kazdego konta osobno
  end
  def replenish_fields   
    @unique_sector_numbers = []
    CSV.foreach(@csv_path+"/fields.csv") do |row|
       @unique_sector_numbers << row[0].to_i
    end
    @unique_sector_numbers.uniq!       
    @unique_sector_numbers.each do |sector|   
      @sector_key = case sector
        when 1 then Key.NUM1
        when 2 then Key.NUM2 
        when 3 then Key.NUM3
        when 4 then Key.NUM4
        when 5 then Key.NUM5
        when 6 then Key.NUM6 
        when 7 then Key.NUM7        
        when 8 then Key.NUM8       
        when 9 then Key.NUM9                       
      end 
      @sikuli.type(@sector_key) 
      sleep(0.5)
      # @screen.move_to 
      begin
        empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_field.png").similar(0.8))
        @total_found = 0
        empty.each do |field|  # ISTOTNE : sprawdzic czy nie bedzie konkurencji pomiedzy findami - obiekty powinny byc hermetyczne ale nie wiadomo czy sie nie odcachuja jak im cos odjebie - wtedy wykonanie finda w build_building moze wyczyscic findy z empty fieldami
          @total_found +=1
        end
        puts "total number of fields to build : #{@total_found}" 
        if  @total_found < 3
          empty.each do |field|  # ISTOTNE : sprawdzic czy nie bedzie konkurencji pomiedzy findami - obiekty powinny byc hermetyczne ale nie wiadomo czy sie nie odcachuja jak im cos odjebie - wtedy wykonanie finda w build_building moze wyczyscic findy z empty fieldami
            loc = Location.new(field.get_center.get_x, field.get_center.get_y)
            build_building(3, "field_2", loc)
          end
        else 
          repetitions = (@total_found/3).ceil
          repetitions.times {|i|
            3.times {|s|
              if @total_found > 0 
                next_field = empty.next
                puts "testing purposes : next field is - #{next_field}"
                loc = Location.new(next_field.get_center.get_x, next_field.get_center.get_y)
                build_building(3, "field_2", loc)
                @total_found -=1 
              end
              #TODO logowanie licznikow iteracji + testy
            }
            if @total_count > 0 
              sleep(180)
            end  
           }
        end  
      rescue
      end
    end
   end
    
   def replenish_wells
    @unique_sector_numbers = []
    CSV.foreach(@csv_path+"/wells.csv") do |row|
       @unique_sector_numbers << row[0].to_i
    end
    @unique_sector_numbers.uniq!
    @unique_sector_numbers.each do |sector| 
      @sector_key = case sector
        when 1 then Key.NUM1
        when 2 then Key.NUM2 
        when 3 then Key.NUM3
        when 4 then Key.NUM4
        when 5 then Key.NUM5
        when 6 then Key.NUM6 
        when 7 then Key.NUM7        
        when 8 then Key.NUM8       
        when 9 then Key.NUM9                       
      end 
      @sikuli.type(@sector_key) 
      sleep(0.5)
      # @screen.move_to 
      begin
        empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_well.png").similar(0.8))
        @total_found = 0
        empty.each do |well|  # ISTOTNE : sprawdzic czy nie bedzie konkurencji pomiedzy findami - obiekty powinny byc hermetyczne ale nie wiadomo czy sie nie odcachuja jak im cos odjebie - wtedy wykonanie finda w build_building moze wyczyscic findy z empty fieldami
          @total_found +=1
        end
        puts "total number of wells to build : #{@total_found}" 
        if  @total_found < 3
          empty.each do |well|  # ISTOTNE : sprawdzic czy nie bedzie konkurencji pomiedzy findami - obiekty powinny byc hermetyczne ale nie wiadomo czy sie nie odcachuja jak im cos odjebie - wtedy wykonanie finda w build_building moze wyczyscic findy z empty fieldami
            loc = Location.new(well.get_center.get_x, well.get_center.get_y)
            build_building(3, "well_2", loc)
          end
        else 
          repetitions = (@total_found/3).ceil
          repetitions.times {|i|
            3.times {|s|
              if @total_found > 0 
                next_well = empty.next
                puts "testing purposes : next well is - #{next_well}"
                loc = Location.new(next_well.get_center.get_x, next_well.get_center.get_y)
                build_building(3, "well_2", loc)
                @total_found -=1 
              end
              #TODO logowanie licznikow iteracji + testy
            }
            if @total_count > 0 
              sleep(180)
            end  
           }
        end  
      rescue
      end
    end
   end  
   
  def rebuild_iron_mines
    @unique_sector_numbers = []
    @counts = {}
    @csv_hash = {}
    10.times {|i|
      @counts[i] = 0
      @csv_hash[i] = []
      }
    CSV.foreach(@csv_path+"/build_eisen.csv") do |row|
       @unique_sector_numbers << row[0].to_i
       @csv_hash[row[0].to_i] << [row[1].to_i, row[2].to_i]  #tu powinno byc dopisywanie a nie nadpisywanie
       @counts[row[0]] +=1
    end
    @unique_sector_numbers.uniq!
    @unique_sector_numbers.each do |sector| 
      @sector_key = case sector
        when 1 then Key.NUM1
        when 2 then Key.NUM2 
        when 3 then Key.NUM3
        when 4 then Key.NUM4
        when 5 then Key.NUM5
        when 6 then Key.NUM6 
        when 7 then Key.NUM7        
        when 8 then Key.NUM8       
        when 9 then Key.NUM9                       
      end 

      @sikuli.type(@sector_key) 
      sleep(0.5)
      @total_to_build = @csv_hash[sector].size
      # @screen.move_to 
      begin
        puts "total number of mines to build : #{@total_to_build}" 
        if  @total_to_build < 3
           @csv_hash[sector].each do |coords|  
              loc = Location.new(coords[0], coords[1])
              build_building(3, "eisen_mine", loc)
          end
        else 
          @overflow = 0
          @csv_hash[sector].each do |coords|  
              loc = Location.new(coords[0], coords[1])
              build_building(3, "eisen_mine", loc)
              puts "iron mine build on location #{}"
              @total_to_build -=1
              @overflow +=1
              if @overflow >=3 
                @overflow = 0
                sleep(270)
              end
          end           
        end  
      rescue
      end
    end
   end
end