require 'java'
require 'rubygems'

$CLASSPATH << "D:\sikuli"
$JAVA_HOME = "C:\Program Files (x86)\Java\jre6" 
# jar przeniesiony do katalogu z projektem zeby uniknac jebania sie z classpathem
#
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
    attr_accessor :screen, :sikuli, :image_path
    
    def initialize
      @screen = Screen.new
      @sikuli = SikuliScript.new
      @image_path = File.dirname(File.expand_path($0))
    end
    
    def star_menu
      @sikuli.switch_app("Chrome")
      @screen.click(@screen.find("#{self.image_path}/star.png"))
	  #@screen.find_all("#{self.image_path}/star.png").each do |result|  # zupelnie zbedne, ale moze zostac jako example
	  # @screen.click(result)	
	  #end
    end
    
	def object_exists?(object)  #wrapper dziala cudownie
		begin
		  puts object
		  pattern = new Pattern(object)
		  pattern.similar(0.2)
			match = @screen.find(pattern)
			puts 'object lookup successful'
			puts @screen.to_s
			puts @screen
			return 1
		rescue 
			puts 'exception catched from: object not found'
			return 0
		end			
	end
	def scroll_to_geo
	#	while not @screen.exists("#{self.image_path}/geo.png") do
	 @limiter = 0
		while object_exists?("#{self.image_path}/geo.png") != 1 && @limiter < 6 do           #BUG : finder lapie portret geologa w gornym lewym rogu na wiadomosci o wyslaniu; zaimplementowac find_in_region
			puts 'no geo visible on screen, scrolling down .. '                #BUG : exists najwyrazniej nie odroznia wyszarzonego geo od zwyklego
			@screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
			sleep(1)
			@limiter +=1
			puts @limiter
		end	
	end	
	
	 def scroll_to_baskets  #refactor
    while object_exists?("#{self.image_path}/basket.png") != 1 do
      puts 'no baskets visible on screen, scrolling down .. '                #BUG : exists najwyrazniej nie odroznia wyszarzonego geo od zwyklego
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
      sleep(0.5)
    end 
  end 
 def send_geo_for(resource, geo)
	puts 'sending geo .. '
    @screen.click(geo)
	puts 'choosing resource .. '
    @screen.click(@screen.find("#{self.image_path}/r_#{resource}.png")) #konwencja nazewnicza dla obrazkow z zasobami
    @screen.click(@screen.find("#{self.image_path}/ok_button.png")) 
  end
     
  def find_all_resource(resource, count)
    while count > 0 do 
      star_menu 
	    puts "count is  : #{count}"	
      scroll_to_geo
      puts @screen
      @geo_row  = @screen.find_all("#{self.image_path}/geo.png")   #zwraca kolekcje, ale zapisuje obiekty po coordach i to nie uwzglednia zmiany widoku
      # zmienic logike, jesli scrollowanie pojdzie za daleko to find_all zbierze wszystkich geo i iterujac sie po nich wysle wszystkich na poszukiwania nie patrzac na limit - bo ten jest na zewnatrz petli _each
	#  puts "row size equals : #{@geo_row.size}"
      @geo_row.each do |geo|
        send_geo_for(resource, geo) #do tej metody trzeba bedzie podac obiekt matchera, bedzie to wymagalo przetestowania 
        count -= 1
		star_menu
		puts count
      end
    end        
  end
       
  def find_all_marmor
    find_all_resource('marmor', 10)  
  end     
  def find_all_iron
   find_all_resource('eisen', 14)  
  end 
  def find_all_gold
    find_all_resource('gold', 8)
  end 
  def buff_building(coord)  #argument definition not yet specified
    star_menu
    @screen.click(@screen.find("#{self.image_path}/l_buffs.png"))
    scroll_to_baskets
    @screen.click(@screen.find("#{self.image_path}/basket.png"))    #zalozenie, ze przy kilku koszykach w polu widzenia wybierze dowolny, a przy jednym - jedyny - wiec nie trzeba kombinowac z iterowaniem albo wybieraniem elementu z kolekcji 
    @screen.click(coord)  
    check_for_cancel_button
      if object_exists?("#{self.image_path}/b_cancel.png") == 1
        @screen.click(@screen.find("#{self.image_path}/b_cancel.png"))
      end   
  end
  
  def buff_building_group(coords)
    @coord_group = coords
    @coord_group.each do |coord|
      sector = coord[0]
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
      location = new Location(coord[1], coord[2])
      buff_building(location)
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
  end  
##################################################################################
#
# new unmerged 15.07
#  
##################################################################################
  def scroll_to_explorer
    @limiter = 0
    while object_exists?("#{self.image_path}/explorer.png") != 1 && @limiter < 7 do           #BUG : finder lapie portret geologa w gornym lewym rogu na wiadomosci o wyslaniu; zaimplementowac find_in_region
      puts 'no geo visible on screen, scrolling down .. '                #BUG : exists najwyrazniej nie odroznia wyszarzonego geo od zwyklego
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
      sleep(1)
      @limiter +=1
      puts @limiter
    end 
  end
  def send_explorer_for_treasure(explorer, length)  #tutaj przetestowac czy wystarczy zalozenie, ze coordy sa zapisane w matcherze, i iterujac sie po matcherze nie bedziemy jeszcze raz wykonywac finda i lapac portretow w lewym gornym rogu; jesli nie to potencjalnie trzeba jeszcze raz instnacjonowac region i wykonywac finda w kazdej iteracji zeby bylo bezpiecznie
    @screen.click(explorer)
    @screen.click(@screen.find("#{self.image_path}/find_treasure.png"))) #TODO : porownac ikonki poszczegolny
    case length
      when "short" then @screen.click(@screen.find("#{self.image_path}/treasue_short.png"))    #zastapic koordynatami jesli rozpoznawanie ikonek nie bedzie zbyt dokladne
      when "medium" then @screen.click(@screen.find("#{self.image_path}/treasure_medium.png"))
      when "long" then @screen.click(@screen.find("#{self.image_path}/treasure_long.png"))
      when "longest" then @screen.click(@screen.find("#{self.image_path}/treasure_longest.png"))
    end  
    @screen.click(@screen.find("#{self.image_path}/ok_button.png")))
  end  
  def find_treasure(length)    
    star_menu
    scroll_to_explorer
    4.times {|i| 
      region = Region.new(740,510,500,400)  #wypchnac to do zmiennej instancjowej, ale koniecznie sprawdzic czy region rejestruje zawartosc czy tylko ogranicza koordynaty szukania - jesli to pierwsze to przy kazdej okazji trzeba go reinstancjonowac
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
      sleep(10)  #control sleep dla pewnosci ze przy zbiorowym wysylaniu grubych nie bedzie opoznien i wyslany nie bedzie swiecil sie na jasno jeszcze przez pare sek. Nie ma problemu z 10 sek bo i tak czynnosc jest wykonywana raz dziennie.
      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
    } 
  end
end
