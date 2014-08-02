require 'abstractmultibot'

class Multi2bot < AbstractMultiBot
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
	def initialize(variant)
		@browser = "Safari"
		@user = "multi2"
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@sikuli_executor = Executor.new(variant, "multi2", @browser)
		@image_path = File.dirname(File.expand_path($0))+"/res"
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/multi2"
		elsif @variant == "work"
			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/multi2"
			#login
			@sikuli.switch_app("C:\\Program Files (x86)\\Safari\\Safari")
			begin
				@screen.wait("#{@image_path}/a_m2.png",20)
				@screen.click(@screen.find("#{@image_path}/b_play.png"))
				sleep(10)
				@screen.wait("#{@image_path}/a_m2.png",20)
				@screen.click(@screen.find("#{@image_path}/ok_button.png"))
			rescue => e
				puts e
			end
		end

	end

end

instance = Multi2bot.new("work")
instance.buff_main_goldmines
instance.buff_main_goldsmelters_min
