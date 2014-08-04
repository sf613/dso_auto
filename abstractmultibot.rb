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

	def composite_action
		@variant = ARGV[0]
		if ARGV[1] == "buffs"
			ARGV[2..-1].each do |a|
				if a == "goldmine"
					buff_main_goldmines
				elsif 	a == "gold"
					buff_main_goldsmelters
				elsif 	a == "gold_m"
					buff_main_goldsmelters_min
				elsif 	a == "coins"
					buff_main_coinmakers
				elsif 	a == "coins_m"
					buff_main_coinmakers_min
				elsif 	a == "towers"
					buff_main_goldtowers
				elsif 	a == "ironmine"
					buff_main_ironmines
				elsif 	a == "iron"
					buff_main_ironsmelters
				elsif 	a == "ironsword"
					buff_main_ironswords
				elsif 	a == "steel"
					buff_main_steelsmelters
				elsif 	a == "steelsword"
					buff_main_steelswords
				elsif 	a == "bronzesword"
					buff_main_bronzeswords
				elsif 	a == "bronze"
					buff_main_copper_smelters
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

