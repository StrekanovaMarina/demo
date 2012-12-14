#encoding: utf-8
# == Schema Information
#
# Table name: water_infos
#
#  id            :integer          not null, primary key
#  mont          :date
#  number_flat   :integer
#  user_id       :integer
#  water_wc      :integer
#  water_kitchen :integer
#  kons_w        :integer
#  kons_k        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class WaterInfo < ActiveRecord::Base
  attr_accessible :cons, :mont, :number_flat, :user_id, :water_kitchen, :water_wc
  belongs_to :user

  
  validates :number_flat, :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :water_kitchen, :presence => true, :numericality => { :only_integer => true, :greater_than => -> water_info {water_info.get_previos.try(:water_kitchen).to_i} }
  validates :water_wc, :presence => true, :numericality => { :only_integer => true, :greater_than => -> water_info {water_info.get_previos.try(:water_wc).to_i} }

  before_validation :check_month

  def check_month
    self.errors.add(:mont, "Вы уже вводили значения в это месяце") if WaterInfo.where(:user_id => self.user_id).order('created_at DESC').first.mont == self.mont
  end

  def get_previos
    WaterInfo.where('id != ? and user_id = ?', self.id, self.user_id).where('mont < ?', self.mont).order('mont DESC').first
  end 


  # def search_p
  #   unless search_params.blank?
  #     date = Date.new(search_params["mont(1i)"].to_i, search_params["mont(2i)"].to_i, 1)
  #     @house1_wi = @house1_wi.where('mont <= ? and mont >= ?',date.end_of_month, date.beginning_of_month)
  #     @house1_wi = @house1_wi.where('mont <= ? and mont >= ?',date.end_of_year, date.beginning_of_year)
  #     @house2_wi = @house2_wi.where('mont <= ? and mont >= ?',date.end_of_month, date.beginning_of_month)
  #     @house2_wi = @house2_wi.where('mont <= ? and mont >= ?',date.end_of_year, date.beginning_of_year)
  #   end
  # end

end
