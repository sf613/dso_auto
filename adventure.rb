require 'java'
require 'rubygems'
require 'sikuli-script.jar'
require 'csv'
require 'convenience'

java_import 'org.sikuli.script.App'
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

class Adventure 
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant, :player2, :player3
	def initialize(variant, user)
		@player2 = nil
		@player3 = nil
		@browser = "Chrome"
		@user = user
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@sikuli_executor = Executor.new(variant, "main", @browser)
		@army = Army.new(variant, "main", @browser)
		@image_path = File.dirname(File.expand_path($0))+"/res"
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/main"
			@gen_coords_path = @image_path+"/xyHome/#{@user}"
		elsif @variant == "work"
			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/main"
			@gen_coords_path = @image_path+"/xyWork/#{@user}"
		end
		@gen_coords = {}
		CSV.foreach(@csv_path+"/fields.csv") do |row|
			@gen_coords[row[0]] = [row[1], row[2]]
		end
	end
	
	def assign_troops(params_hash)
		
=begin
	{
		:gen1 => {
			:recruit => 120
			:bowman => 150
		}
	}
=end
		params_hash.each do |gen_name, units|
			#gen number - na pierwszym widoku powinno byc widac 12 genkow, co chyba wystarczy zeby przeniesc wojsko assignujac grupy kazdemu z osobna indeksujac ich 1-12. 

			@screen.click(Location.new(@gen_coords[gen_name][0], @gen_coords[gen_name][1]))
			units.keys.each do |unit_type|
				case unit_type
				when :recruit 
					#click on input field next to :recruit
					input(units[:recruit])	
				when :bowman
					#click on input field next to :bowman
					input(units[:recruit])	
				when :militia 
					#click on input field next to :recruit
					input(units[:militia])	
				when :swordsman 
					#click on input field next to :recruit
					input(units[:swordsman])	
				when :longbowman 
					#click on input field next to :recruit
					input(units[:longbowman])	
				when :cavalry 
					#click on input field next to :recruit
					input(units[:cavalry])	
				when :elite 
					#click on input field next to :recruit
					input(units[:elite])	
				when :crossbowman
					#click on input field next to :recruit
					input(units[:crossbowman])	
				when :cannon 
					#click on input field next to :recruit
					input(units[:cannon])	
				end				
			end
			#click OK
		end		
	end
	
	def send_generals
		#open 'send army' perspective
		#check all generals to be sent
		## jesli nie bedzie problemow z sortowaniem w widoku wysylania to mozna wysylac pierwszych 12tu czy ilu ich tam jest z widoku glownego - bo nawet jesli bedzie potrzeba wiecej wojska to sie czesc zawroci (chociaz to juz moze byc skomplikowane); 
	end
	
	def switch_to_adv
		#click adv minature
		@screen.click(@screen.find("#{self.image_path}/adv_besuchen.png"))
		#sleep 20
	end
	
	def select_adv(name)
		star_menu
		#select adv bookmark
		scroll_to_adv(name)
		#click on first adv of that name
		#click OK
	end
	
	def scroll_to_adv(name)
	    @limiter = 0
	    while object_exists?("#{self.image_path}/adv/#{name}.png", 0.75) != 1 && @limiter < 6 do
	      puts 'no adv of that name visible on screen, scrolling down .. '
	      @screen.click(@screen.find("#{self.image_path}/b_scrollDown.png"))
	      sleep(1)
	      @limiter +=1
	    end
	    puts "adventure found in the view!"
	end
	
	def invite(player)
		#click adv minature
		@screen.click(@screen.find("#{self.image_path}/adv_details.png"))
		#click invite
		#focus input
		type(player)
		#press OK
	end
	
	def select_gen_on_adv(type)
		
	end
	
	def unload_all_gens_on_adv
		#open menu
		@gen_coords.each do |name, coords|
			@screen.click(Location.new(coords[0], coords[1]))
			unload_gen_on_adv
			@screen.click(@screen.find(close_button))
		end	
	end
	def unload_gen_on_adv
		
	end
	
	def move_gen_to_starting_zone(general, zone_number)       #zone number = clock notation
		#open specialist menu
		#select 
	end
	
end