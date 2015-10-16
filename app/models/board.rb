class Board < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  has_many :applications, dependent: :destroy
  has_many :notes, dependent: :destroy

  def self.stages
    stages = Array["Applied", "Interviewing", "Waiting", "Offered"]#, "Discontinued"]
    return stages
  end
end
