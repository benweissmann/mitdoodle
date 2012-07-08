class Option < ActiveRecord::Base
  has_many :votes, :dependent => :destroy
  has_many :users, :through => :votes
  belongs_to :poll

  # delete current votes if the option changes
  after_update :delete_votes

  def yes_votes_count
    self.votes.where(['yes = ?', true]).size
  end

  private

  def delete_votes
    self.votes.each(&:destroy)
  end
end