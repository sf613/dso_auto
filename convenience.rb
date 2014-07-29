require 'rubygems'
class Convenience
      attr_accessor :screen, :sikuli, :image_path, :count, :variant
  # static methods 
  
   def self.jump_to_sector(number,ref_image_path, screen)
     screen.type(screen.find(Pattern.new("#{ref_image_path}/warehouse_focuspoint.png").similar(0.35)), number.to_s)     #na defaultowej zgodnosci z obrazkiem wykrywa go na wszystkich sektorach, sprawdzic w domu
     begin
     screen.click(screen.find("#{ref_image_path}/close_window.png"))  
     rescue => e
       puts e  
     end
   end
   def self.drag_to_location(locStart, locEnd, screen)
     screen.drag_drop(locStart,locEnd)
   end
      
end

#scrolls : drag_to_location(Location.new(608,184), Location.new(608,378)  dla hut zlota #home #sector 2
#          drag_to_location(Location.new(618,390), Location.new(402,543)  dla hut miedzi #home #sector 1