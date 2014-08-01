require 'abstractbot'

class Multi1bot < AbstractBot
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
	def initialize(variant)
		@browser = "FireFox"
		@user = "multi1"
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@sikuli_executor = Executor.new(variant,"multi1", @browser)
		@image_path = File.dirname(File.expand_path($0))+"/res"
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/multi1"
		elsif @variant == "work"

			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/multi1"
			#login
			@sikuli.switch_app("C:\\Program Files (x86)\\Mozilla Firefox\\firefox")
			@screen.wait("#{@image_path}/a_m1.png",20)
			@screen.click(@screen.find("#{@image_path}/b_play.png"))
			sleep(10)
			@screen.wait("#{@image_path}/a_m1.png",20)
			@screen.click(@screen.find("#{@image_path}/ok_button.png"))
		end

	end

	def buff_main_bakeries
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_bakeries
	end

	def buff_main_bows
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_bows
	end

	def buff_main_bronzeswords
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_bronzeswords
	end

	def buff_main_copper_smelters
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_copper_smelters
	end

	def buff_main_goldtowers
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_goldtowers
	end

	def buff_main_goldmines
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_goldmines
	end

	def buff_main_goldsmelters
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_goldsmelters
	end

	def buff_main_goldsmelters_min
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_min_goldsmelters
	end

	def buff_main_coinmakers
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_coinmakers
	end

	def buff_main_coinmakers_min
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_min_coinmakers
	end

	def buff_main_toolmakers
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_toolmakers
	end
end#of class

instance = Multi1bot.new("work")
instance.rebuild_fields
