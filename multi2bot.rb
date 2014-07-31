require 'abstractbot'

class Multi2bot < AbstractBot
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
		end
						
		#login
		@sikuli.switch_app("C:\\Program Files (x86)\\Safari\\Safari") # hack : sa problemy z focusowaniem aplikacji jesli jest kilka uruchomionych przegladarek, stad skrypt nie bedzie odpalany przy zalogowanym multi tylko uwzgledni tez proces logowania
		#important  : jest poczynione zalozenie ze przegladarki maja zapamietane dane logowania i odtwarzaja sesje po kazdym starcie bez koniecznosci manualnej interwencji
		begin
			@screen.wait("#{@image_path}/a_m2.png",20)                # w teorii jesli przegladarka jest otwarta i multi zalogowane to nawet po otwarciu nowego focus pozostanie na pierwszym, wiec nie ma sensu zeby brak ikon do logowania wywalal skrypt exceptionem
			@screen.click(@screen.find("#{@image_path}/b_play.png"))
			sleep(10)
			@screen.wait("#{@image_path}/a_m2.png",20)
			@screen.click(@screen.find("#{@image_path}/ok_button.png"))
		rescue => e
			puts e
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
end

instance = Multi2bot.new("work")
instance.buff_main_bows
