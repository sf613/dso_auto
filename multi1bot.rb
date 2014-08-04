require 'abstractmultibot'

class Multi1bot < AbstractMultiBot
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
end#of class

instance = Multi1bot.new(ARGV[0])
instance.composite_action
