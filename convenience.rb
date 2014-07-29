require 'rubygems'
class Convenience
      attr_accessor :screen, :sikuli, :image_path, :count, :variant
  # static methods 
  
   def self.jump_to_sector(number,ref_image_path, screen)
     screen.type(screen.find("#{ref_image_path}/warehouse_focuspoint.png"), number.to_s)     #na defaultowej zgodnosci z obrazkiem wykrywa go na wszystkich sektorach, sprawdzic w domu
   end
      
end