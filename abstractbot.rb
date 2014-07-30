require 'java'
require 'rubygems'
require 'executor'
require 'builder'
require 'convenience'
require 'tolerances'

class AbstractBot
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
	def initialize(variant)
		@browser = "Chrome"
		@user = "main"
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@sikuli_executor = Executor.new(variant, "main", @browser)
		@image_path = File.dirname(File.expand_path($0))+"/res"
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/main"
		end
	end

	def switch_to_main
		begin
			if @user != "main"
				@sikuli.switch_app(@browser)
				@screen.click(@screen.find(Pattern.new("#{@sikuli_executor.image_path}/switch_portrait.png").similar(0.8)))
				sleep(1)
				@screen.click(@screen.find("#{@sikuli_executor.image_path}/besuchen.png"))
				@screen.wait("#{@sikuli_executor.image_path}/city_centre.png", 40)
			end
		rescue
		end
	end

	def handle_marmor_find
		@sikuli_executor.find_all_resource("marmor", 3)
	end

	def handle_iron_find
		@sikuli_executor.find_all_resource("eisen", 14)
	end

	def handle_gold_find
		@sikuli_executor.find_all_resource("gold", 8)
	end

	def read_coords_from_file(filepath)
		@coords = CSV.read(filepath)
	end

	#
	#  BUFFING
	#
	def buff_all_bakeries
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/bakeries.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_bows
		begin
			@sikuli.switch_app(@browser)
			switch_to_main
			coords = read_coords_from_file("#{@csv_path}/bows.csv")
			@sikuli_executor.buff_building_group(coords)
		rescue => e
			puts e
		end
	end

	def buff_all_bronzeswords
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/bronzeswords.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_copper_smelters
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/copper_smelters.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_goldsmelters
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/goldsmelters.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_coinmakers
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/coins.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_min_coinmakers
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/coins_min.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_goldmines
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/goldmines.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_min_goldmines
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/goldmines_min.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	def buff_all_goldtowers
		@sikuli.switch_app(@browser)
		switch_to_main
		coords = read_coords_from_file("#{@csv_path}/goldtowers.csv")
		@sikuli_executor.buff_building_group(coords)
	end

	#
	#  MINES
	#
	def rebuild_gold_work
		BobTheBuilder.new("work",@user,@browser).rebuild_gold_mines
	end

	def rebuild_iron_work
		BobTheBuilder.new("work",@user,@browser).rebuild_iron_mines
	end

	def rebuild_fields
		BobTheBuilder.new("work",@user,@browser).replenish_fields
	end
end
