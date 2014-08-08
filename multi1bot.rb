require 'abstractmultibot'

class Multi1bot < AbstractMultibot
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
			@sikuli.switch_app("Siedler")
			@screen.wait(Pattern.new("#{@image_path}/a_m1.png").similar(0.8),20)
			@screen.click(@screen.find(Pattern.new("#{@image_path}/b_play.png").similar(0.85)))
			sleep(10)
			@screen.wait(Pattern.new("#{@image_path}/a_m1.png").similar(0.8),20)
			@screen.click(@screen.find("#{@image_path}/ok_button.png"))
		end

	end
end#of class

instance = Multi1bot.new(ARGV[0])
instance.composite_action
