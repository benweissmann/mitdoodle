class Vote < ActiveRecord::Base
  belongs_to :option
  belongs_to :user
  has_one :poll, :through => :option
end
