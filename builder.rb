require 'java'
require 'rubygems'

# jar przeniesiony do katalogu z projektem zeby uniknac jebania sie z classpathem
#
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
    
  def build_building(category, name, location)
    @screen.click(building_menu_coords)  #koordy tej ikony sa stale
    case category
      when 1 then @screen.click(@screen.find("#{self.image_path}/building_cat1.png"))    #nie ma chyba sensu wykonywac za kazdym razem finda, lepiej zebrac coordy, bo i tak sa sztywne - po otwarciu menu jego polozenie i rozmiar sa zawsze takie same, mozna je przesuwac ale pozycja sie nie cachuje po zamknieciu.
        # coordy mozna sprawdzic robiac w jednolinijkowcu finda i clicka, na konsoli pokaze sie miejsce wykonania clicka
      when 2 then @screen.click(@screen.find("#{self.image_path}/building_cat2.png"))
      when 3 then @screen.click(@screen.find("#{self.image_path}/building_cat3.png"))
      when 4 then @screen.click(@screen.find("#{self.image_path}/building_cat4.png"))
    end
    @screen.click(@screen.find("#{self.image_path}/b_#{name}.png")) 
    @screen.doouble_click(location) 
  end 
  
  def replenish_fields   #prototyp, rozwiazac problemy z niewidocznoscia pewnych kluczowych obszarow przy skoku do sektora - trzeba zastosowac scrolling albo jakas metode przeskakujaca centerem do pktu na ekranie
    #poczynione zalozenie ze nie replenishujemy niczym innym niz tylko field_2
    CSV.foreach(@csv_path+"/fields") do |row|
       sector = row[0]
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
      empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_field.png").similar(0.8))
      empty.each do |field|  # ISTOTNE : sprawdzic czy nie bedzie konkurencji pomiedzy findami - obiekty powinny byc hermetyczne ale nie wiadomo czy sie nie odcachuja jak im cos odjebie - wtedy wykonanie finda w build_building moze wyczyscic findy z empty fieldami
        loc = Location.new(field.get_center.get_x, field.get_center.get_y)
        build_building(3, "field_2", loc)
      end
    end
   end
    
   def replenish_wells
    CSV.foreach(@csv_path+"/wells") do |row|
      sector = row[0]
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
      empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_well.png").similar(0.6))
      empty.each do |well|
        loc = Location.new(well.get_center.get_x, well.get_center.get_y)
        build_building(3, "well_2", loc)
      end
    end
   end  
end