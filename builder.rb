require 'java'
require 'rubygems'
require 'sikuli-script.jar'
require 'csv'
require 'convenience'

java_import 'org.sikuli.script.App'
java_import 'org.sikuli.script.Region'
java_import 'org.sikuli.script.Screen'
java_import 'org.sikuli.script.Finder'
java_import 'org.sikuli.script.Match'
java_import 'org.sikuli.script.Key'
java_import 'org.sikuli.script.Pattern'
java_import 'org.sikuli.script.Location'
java_import 'org.sikuli.script.Settings'
java_import 'org.sikuli.script.SikuliEvent'
java_import 'org.sikuli.script.SikuliScript'
class BobTheBuilder
	attr_accessor :screen, :sikuli, :image_path, :count, :variant, :user
	def initialize(variant,user,browser)
		@browser = browser
		@screen = Screen.new
		@sikuli = SikuliScript.new
		@image_path = File.dirname(File.expand_path($0))+"/res"
		#@action_count = action_count
		@variant = variant
		if @variant == "home"
			@star_menu_region = Region.new(480,270,400,260)
			@csv_path = @image_path+"/xyHome/#{user}"
      @building_menu_coords = [440,589]
      @building_window = Region.new(269,153,340,380)
		elsif @variant == "work"
			@star_menu_region = Region.new(760,560,400,280)
			@csv_path = @image_path+"/xyWork/#{user}"
			@building_menu_coords = [718,899]
			@building_window = Region.new(547,464,340,400)    
		end
	end

	def build_building(category, name, location)
		@screen.click(Location.new(@building_menu_coords[0], @building_menu_coords[1]))
		case category
		when 1 then @screen.click(@screen.find("#{self.image_path}/building_cat1.png"))
		when 2 then @screen.click(@screen.find("#{self.image_path}/building_cat2.png"))
		when 3 then @screen.click(@screen.find("#{self.image_path}/building_cat3.png"))
		when 4 then @screen.click(@screen.find("#{self.image_path}/building_cat4.png"))
		end
		@screen.click(@building_window.find("#{self.image_path}/b_#{name}.png"))
		sleep(1)
		@screen.double_click(location)
		sleep(1)
	end
	
	def replenish_fields
		@current_queue_size = 0
		#@sikuli.switch_app(@browser)
		App.focus(@browser)
		@timeout = 180
		@unique_sector_numbers = []
		CSV.foreach(@csv_path+"/fields.csv") do |row|
			@unique_sector_numbers << row[0].to_i
		end
		@unique_sector_numbers.uniq!
		@unique_sector_numbers.each do |sector|
			Convenience.jump_to_sector(sector, @image_path, @screen)
			sleep(0.5)
			# @screen.move_to
			begin
				@empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_field.png").similar(0.5))
				@total_found = 0
				p @empty
				begin
					@empty.each do |field|          
						begin
						    if @current_queue_size < 3
								p field
								loc = Location.new(field.get_center.get_x, field.get_center.get_y)
								build_building(3, "field_2", loc)
								@current_queue_size +=1
								puts "queue : #{@current_queue_size}"
							else 
							    sleep(@timeout)
							    loc = Location.new(field.get_center.get_x, field.get_center.get_y)
							    build_building(3, "field_2", loc)
							    @current_queue_size = 1
							end   
						rescue => e
							puts e
						end
					end
				rescue => e
					puts e
				end

			rescue => e
				puts e
			end
		end
	end

	def replenish_wells
		@sikuli.switch_app(@browser)
		@timeout = 180
		@unique_sector_numbers = []
		CSV.foreach(@csv_path+"/wells.csv") do |row|
			@unique_sector_numbers << row[0].to_i
		end
		@unique_sector_numbers.uniq!
		@unique_sector_numbers.each do |sector|
			Convenience.jump_to_sector(sector, @image_path, @screen)
			sleep(0.5)
			# @screen.move_to
			begin
				empty = @screen.find_all(Pattern.new("#{self.image_path}/empty_well.png").similar(0.5))
				@total_found = 0
				empty.each do |well|  
					@total_found +=1
				end
				puts "total number of wells to build : #{@total_found}"
				if  @total_found < 3
					empty.each do |well|  
						loc = Location.new(well.get_center.get_x, well.get_center.get_y)
						build_building(3, "well_2", loc)
					end
				else
					repetitions = (@total_found/3).ceil
					repetitions.times {|i|
						3.times {|s|
							if @total_found > 0
								next_well = empty.next
								puts "testing purposes : next well is - #{next_well}"
								loc = Location.new(next_well.get_center.get_x, next_well.get_center.get_y)
								build_building(3, "well_2", loc)
								@total_found -=1
							end
						#TODO 
						}
						if @total_count > 0
							sleep(@timeout)
						end
					}
				end
			rescue
			end
		end
	end

	def rebuild_iron_mines
		@sikuli.switch_app(@browser)
		@timeout = 360
		@unique_sector_numbers = []
		@counts = {}
		@csv_hash = {}
		10.times {|i|
			@counts[i] = 0
			@csv_hash[i] = []
		}
		CSV.foreach(@csv_path+"/ironmines.csv") do |row|
			@unique_sector_numbers << row[0].to_i
			@csv_hash[row[0].to_i] << [row[1].to_i, row[2].to_i] 
			@counts[row[0].to_i] +=1
		end
		@unique_sector_numbers.uniq!
		@current_queue_size = 0
		@unique_sector_numbers.each do |sector|
			Convenience.jump_to_sector(sector, @image_path, @screen)
			sleep(0.5)
			@total_to_build = @csv_hash[sector].size
			begin
				puts "total number of mines to build : #{@total_to_build} in sector #{sector}"
				if  @total_to_build < 3
					@csv_hash[sector].each do |coords|
						if @current_queue_size >=3
							@current_queue_size = 0
							puts "waiting after 3 repetitions .. "
							sleep(@timeout)
						end
						loc = Location.new(coords[0].to_i, coords[1].to_i)
						@screen.mouse_move(loc)
						@current_queue_size +=1
						build_building(3, "iron_mine", loc)
					end
				else

					@csv_hash[sector].each do |coords|
						if @current_queue_size >=3
							@current_queue_size = 0
							puts "waiting after 3 repetitions .. "
							sleep(@timeout)
						end
						loc = Location.new(coords[0], coords[1])
						@screen.mouse_move(loc)
						build_building(3, "iron_mine", loc)
						@current_queue_size +=1
						puts "iron mine build on location #{}"
						@total_to_build -=1
						puts "current_queue_size : #{@current_queue_size}"
					end
				end
			rescue
			end
		end
	end

	def rebuild_gold_mines
		@sikuli.switch_app(@browser)
		@timeout = 640
		@unique_sector_numbers = []
		@counts = {}
		@csv_hash = {}
		10.times {|i|
			@counts[i] = 0
			@csv_hash[i] = []
		}
		CSV.foreach(@csv_path+"/goldmines.csv") do |row|
			@unique_sector_numbers << row[0].to_i
			@csv_hash[row[0].to_i] << [row[1].to_i, row[2].to_i] 
			@counts[row[0].to_i] +=1
		end
		@unique_sector_numbers.uniq!
		@current_queue_size = 0
		@unique_sector_numbers.each do |sector|
			Convenience.jump_to_sector(sector, @image_path, @screen)
			sleep(0.5)
			@total_to_build = @csv_hash[sector].size
			# @screen.move_to
			begin
				puts "total number of mines to build : #{@total_to_build} in sector #{sector}"
				if  @total_to_build < 3
					@csv_hash[sector].each do |coords|
						if @current_queue_size >=3
							@current_queue_size = 0
							puts "waiting after 3 repetitions .. "
							sleep(@timeout)
						end
						loc = Location.new(coords[0].to_i, coords[1].to_i)
						@screen.mouse_move(loc)
						@current_queue_size +=1
						build_building(3, "gold_mine", loc)
					end
				else

					@csv_hash[sector].each do |coords|
						if @current_queue_size >=3
							@current_queue_size = 0
							puts "waiting after 3 repetitions .. "
							sleep(@timeout)
						end
						loc = Location.new(coords[0], coords[1])
						@screen.mouse_move(loc)
						build_building(3, "gold_mine", loc)
						@current_queue_size +=1
						puts "iron mine build on location #{}"
						@total_to_build -=1
						puts "current_queue_size : #{@current_queue_size}"
					end
				end
			rescue
			end
		end
	end
end