require 'java'
require 'rubygems'
require 'executor'
require 'builder'
require 'convenience'
require 'tolerances'
require 'army'

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

class Testclass 
	    attr_accessor :image_path, :screen
    
    def initialize	
    	@image_path = File.dirname(File.expand_path($0))
    	@screen = Screen.new
    end    
 	def observe_for_barracks_menu
 		@barracks_menu_region = Region.new(672,346,600,430)
 		@unit_menu_region = Region.new(830,446,150,150)
 		 		@unit_menu_region.observe
 		@unit_menu_region.on_appear(Pattern.new("#{self.image_path}/recruit.png").similar(0.9),event_handler)

 		sleep(30)
 		@unit_menu_region.stop_observer
 	end
 	def event_handler
 		puts 'wohoo! menu opened'
 	end
 	def sort_all_matches 		
 		@x_coord = []
 		@y_coord = []
 		@match_count = 0
 		@matches = @screen.find_all(Pattern.new("#{@image_path}/1.png").similar(0.65))
 		@matches.each do |match|
 			@x_coord << match.get_x
 			@y_coord << match.get_y
 			@match_count += 1
 		end
 		puts "x total size is #{@x_coord.size}, coords are #{@x_coord}"
 		#puts "y total size is #{@y_coord.size}"
 		@filtered = @x_coord.uniq
 		#@y_coord.uniq!
 		@counts = {}
 		puts "match count is #{@match_count}"
 		puts "x size is #{@x_coord.size}, coords are #{@x_coord}"
 		#puts "y size is #{@y_coord.size}"
 		@matches = @screen.find_all(Pattern.new("#{@image_path}/1.png").similar(0.65))
 		@filtered.each do |uniq_row|
 			@counts[uniq_row] = 0
 			@x_coord.each do |coord|
 				if coord <= uniq_row + 5 && coord >= uniq_row - 5 
 					@counts[uniq_row] +=1
 				end
 			end
 		end
 		puts "complete match hash is #{@counts}"
 	end
end 
instance = Testclass.new
instance.sort_all_matches 

