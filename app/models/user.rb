class User < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  has_many :polls
  
  def polls_voted_in
    Poll.joins(:options => {:votes => :user}).
         where(['users.id = ?', self.id]).
         group('poll_id')
  end
end
