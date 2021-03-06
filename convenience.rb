require 'rubygems'

class Convenience
	attr_accessor :screen, :sikuli, :image_path, :count, :variant
	# static methods
	def self.jump_to_sector(number,ref_image_path, screen)  #optional argument 
		screen.type(Location.new(600,300), number.to_s)
		#BUG : jesli point of click znajduje sie wysoko i laduje pod gorna belka to po
		# jego selecie czasem gra nie reaguje na inputy; pewnie mozna to rozwiazac robiac
		# screena z innego miejsca i wtedy klikanie na selection nie bedzie wlazilo na
		# belke
		sleep(3)  #bug : jesli zbuduje sie budynek i kliknie zmiane sektora to klik na 'x' moze trafic w kolejke budowania jesli budynek nie zaczal sie jeszcze budowac.
		begin
			screen.click(screen.find("#{ref_image_path}/close_window.png"))
		rescue => e
			puts e
		end
	end

	def self.drag_to_location(locStart, locEnd, screen)
	  puts "scrolling the screen"
		screen.drag_drop(locStart,locEnd)
	end

end

#scrolls : drag_to_location(Location.new(608,184), Location.new(608,378),
# @screen)  dla hut zlota #home #sector 2
#          drag_to_location(Location.new(618,390), Location.new(402,543),
# @screen)  dla hut miedzi #home #sector 1
#          drag_to_location(Location.new(711,247), Location.new(711,404),
# @screen)  dla kop zelaza #home #sector 3
#          drag_to_location(Location.new(594,283), Location.new(1047,553),
# @screen)  dla kop zelaza #home #sector 5
