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
class Army
	attr_accessor :screen, :sikuli, :image_path, :count, :variant, :user
	def initialize(variant,user,browser)
		@browser = browser
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@image_path = File.dirname(File.expand_path($0))+"/res"
		#@action_count = action_count
		@variant = variant
		if @variant == "home"
			@barracks_menu_region = Region.new(393,189,600,430)
      @unit_menu_region = Region.new(565,300,130,130)
      @close_barracks = Region.new(939,193,30,30)
      @slider = Location.new(932,429)
			@csv_path = @image_path+"/xyHome/#{user}"
		elsif @variant == "work"
			@barracks_menu_region = Region.new(672,346,600,430)
			@unit_menu_region = Region.new(830,446,150,150)
			@close_barracks = Region.new(1200,345,30,30)
			@slider = Location.new(1211,584)
			@csv_path = @image_path+"/xyWork/#{user}"
		end
	end

	def open_menu
		begin
			@screen.click(@close_barracks.find("#{self.image_path}/close_window.png"))
			puts "before opening the menu : "
		rescue => e
			puts e
		end
		@screen.type(Location.new(600,300), "b")
	end

	def build_units(type, number)
		open_menu
		repetitions = (number.to_i/25).ceil
		while repetitions > 0
			puts "total to build : #{number}, number of cycles : #{repetitions}"
			@screen.click(@unit_menu_region.find("#{self.image_path}/#{type}.png"))
			sleep(1)
			@screen.click(@slider)
			sleep(1)
			@screen.click(@screen.find("#{self.image_path}/ok_button.png"))
			sleep(1)
			repetitions -=1
		end
		begin
			@screen.click(@close_barracks.find("#{self.image_path}/close_window.png"))
		rescue => e
			puts e
		end
	end
end