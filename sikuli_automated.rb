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
	
	def d_click(location)
	  #wrapper for cases when single clicks on screen are not recognized
	  @screen.double_click(location)
	end
	def scroll_to_geo
	#	while not @screen.exists("#{self.image_path}/geo.png") do
	 @limiter = 0
		while object_exists?("#{self.image_path}/geo.png", 0.85) != 1 && @limiter < 6 do           #BUG : finder lapie portret geologa w gornym lewym rogu na wiadomosci o wyslaniu; zaimplementowac find_in_region
			puts 'no geo visible on screen, scrolling down .. '                #BUG : exists najwyrazniej nie odroznia wyszarzonego geo od zwyklego
			@screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
			sleep(1)
			@limiter +=1
		end	
	end	
	
	 def scroll_to_baskets  #refactor
    while object_exists?("#{self.image_path}/basket.png", 0.8) != 1 do
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
    
  def send_geo?(resource,geo)  #convenience
    if @count > 0           
      send_geo_for(resource,geo)
      @count -= 1
      #fixed problem z dekrementacja : pamietac o tym, ze argument jest interpretowany jako nowa zmienna lokalna z referencja do tego samego obiektu, ale niemogaca go mutowac; stad argument usuniety a licznik jest przekazywany jako zmienna instancji i referowana 
      puts "cnt left : #{@count}"
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
      @screen.click(@screen.find("#{self.image_path}/l_buffs.png"))  #convenience, na wypadek gdyby zakladka specow byla przescrollowana: wymyslec jakies inne obejscie.
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
    #BUG FIXED : count sie dekrementuje, trzeba tylko uwazac zeby w kolejnych stepach referencowac zmienna instancjowa @count a nie label argumentu - count
    while @count > 0 
       puts "inside the while loop; count : #{@count}"
       region = @star_menu_region  
       #tutaj moze sie przydac skonstruowanie wrappera do sanityzacji tego czy obiekt jest widoczny
       @screen.click(region.find(Pattern.new("#{self.image_path}/b_scrollDown.png").similar(0.85)))  #FIX NEEDED : minimalne rozszerzenie regionu bo zdarzylo sie ze nie kliknelo scrolla; zamiast tego kliknelo jednego z wyslanych geo (chuj wie dlaczego bo quicktest nie pokazal bledow); ogolnie trzeba calosc rafeactorowac i porozbijac na zagniezdzone metody
       #coordy w ktore kliknelo to 615:386 # fixed, to byl problem z similarity, znajdywalo wiecej obiektow wcale niepodobnych do patternu
       # alternatywny hack : zlozyc okno czatu przed zaczeciem akcji
       @geo_next_row  = region.find_all(Pattern.new("#{self.image_path}/geo.png").similar(0.85))  
       @geo_next_row.each do |geo|
         puts "from inside geo next row; count : #{count}"
         send_geo?(resource,geo)
       end
    end          
  end

  def buff_building(coord)  #argument definition not yet specified
    #dorobic drabinke logiczna zeby niepotrzebnie nie scrollowal
    star_menu
    if object_exists?("#{self.image_path}/basket.png", 0.8) != 1 
      @screen.click(@screen.find("#{self.image_path}/l_specialisten.png"))  #soft reset okna, jesli nie widac na ekranie buffow to trudno stwierdzic czy scroll jest powyzej czy ponizej, wiec lepiej zresetowac
      @screen.click(@screen.find("#{self.image_path}/l_buffs.png")) 
      scroll_to_baskets
    end
    @screen.click(@screen.find("#{self.image_path}/basket.png"))    #zalozenie, ze przy kilku koszykach w polu widzenia wybierze dowolny, a przy jednym - jedyny - wiec nie trzeba kombinowac z iterowaniem albo wybieraniem elementu z kolekcji 
    d_click(coord)  
    #check_for_cancel_button   # chyba pozostalosc po jakiejs innej metodzie albo blad przy kopiownaiu. 
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
    @screen.click(@screen.find("#{self.image_path}/find_treasure.png")) #TODO : porownac ikonki poszczegolny
    case length
      when "short" then @screen.click(@screen.find("#{self.image_path}/treasue_short.png"))    #zastapic koordynatami jesli rozpoznawanie ikonek nie bedzie zbyt dokladne
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
      region = @star_menu_region  #wypchnac to do zmiennej instancjowej, ale koniecznie sprawdzic czy region rejestruje zawartosc czy tylko ogranicza koordynaty szukania - jesli to pierwsze to przy kazdej okazji trzeba go reinstancjonowac
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

