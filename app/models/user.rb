class User < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  
  def polls
    Poll.joins(:options => {:votes => :user}).
         where(['users.id = ?', self.id]).
         group('poll_id')
  end

  def polls_created
    Poll.where(['user_id = ?', self.id])
  end
end
