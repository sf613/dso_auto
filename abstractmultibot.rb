require 'abstractbot'

class AbstractMultibot < AbstractBot
	attr_accessor :sikuli_executor,:screen, :sikuli, :image_path,:variant
	def initialize(variant)

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

	def buff_main_bronzesmelters
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_bronzesmelters
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
	
		def buff_main_ironsmelters
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_ironsmelters
	end
	
		def buff_main_ironswords
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_ironswords
	end
	
			def buff_main_steelsmelters
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_steelsmelters
	end
	
		def buff_main_steelswords
		if @variant == "home"
			@csv_path = @image_path+"/xyHome/main"
		elsif @variant == "work"
			@csv_path = @image_path+"/xyWork/main"
		end
		buff_all_steelswords
	end

	def composite_action
		@variant = ARGV[0]
		if ARGV[1] == "buffs"
			ARGV[2..-1].each do |a|
				if a == "goldmine"
					buff_main_goldmines
				elsif 	a == "goldmines"
					buff_main_goldsmelters
				elsif 	a == "goldsmelters_m"
					buff_main_goldsmelters_min
				elsif 	a == "coins"
					buff_main_coinmakers
				elsif 	a == "coins_m"
					buff_main_coinmakers_min
				elsif 	a == "goldtowers"
					buff_main_goldtowers
				elsif 	a == "ironmines"
					buff_main_ironmines
				elsif 	a == "ironsmelters"
					buff_main_ironsmelters
				elsif 	a == "ironswords"
					buff_main_ironswords
				elsif 	a == "steelsmelters"
					buff_main_steelsmelters
				elsif 	a == "steelswords"
					buff_main_steelswords
				elsif 	a == "bronzeswords"
					buff_main_bronzeswords
				elsif 	a == "bronzesmelters"
					buff_main_bronzesmelters
				elsif 	a == "marmorfind"
					handle_marmor_find
				elsif 	a == "ironfind"
					handle_iron_find
				elsif 	a == "goldfind"
					handle_gold_find
				end
			end
		end
	end
end#of class
