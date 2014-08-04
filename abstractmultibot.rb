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
end#of class

