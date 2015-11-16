class Board < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  has_many :applications, dependent: :destroy
  has_many :notes, dependent: :destroy

  STAGES = Array["Applied",
                 "Interviewing",
                 "Waiting",
                 "Offered"]#, "Discontinued"]

  def self.get_indexed_stages
    indexed_stages = Array.new(STAGES)
    indexed_stages.unshift("")
    return indexed_stages
  end

  def self.get_stage(idx)
    indexed_stages = get_indexed_stages
    if idx.present? && idx > 0 && idx < indexed_stages.length
      return indexed_stages[idx]
    else
      return ""
    end
  end

  def self.stages_for_select
    select_array = [["Choose Stage", ""]]
    STAGES.each_with_index do |stage, index|
      select_array.push([stage, index+1])
    end
    return select_array
  end

end
