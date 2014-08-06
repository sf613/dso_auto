require 'abstractmultibot'

class Multi3bot < AbstractMultibot
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
	def initialize(variant)
		@browser = "Opera"
		@user = "multi3"
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@sikuli_executor = Executor.new(variant, "multi3", @browser)
		@image_path = File.dirname(File.expand_path($0))+"/res"
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/multi3"
		elsif @variant == "work"
			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/multi3"
			#login
			@sikuli.switch_app("Siedler")
			sleep(10)
			@screen.wait(Pattern.new("#{@image_path}/a_m3.png").similar(0.8),20)
			@screen.click(@screen.find(Pattern.new("#{@image_path}/b_play.png").similar(0.85)))
			sleep(10)
			@screen.wait(Pattern.new("#{@image_path}/a_m3.png").similar(0.8),20)
			@screen.click(@screen.find("#{@image_path}/ok_button.png"))
		end

	end

end
 
instance = Multi3bot.new(ARGV[0])
#instance.rebuild_fields
instance.composite_action