class Poll < ActiveRecord::Base
  has_many :options, :dependent => :destroy
  has_many :votes, :through => :options
  belongs_to :user

  accepts_nested_attributes_for :options,
                                :reject_if => lambda {|opt| opt[:label].blank?},
                                :allow_destroy => true

  attr_protected :user_id, :closed, :key, :short_link

  validates :user_id, :title, :key, :presence => true
  validate :cannot_unanon_poll

  # Returns an array of Users who have voted in this poll
  def voters
    User.joins(:votes => {:option => :poll}).
         where(['polls.id = ?', self.id]).
         group('users.id')
  end

  # use they key in urls, not the id
  def to_param
    self.key.to_s
  end

  def generate_short_link
    self.short_link = UrlShortener.shorten(MITDOODLE_PERMALINK_HOME + Rails.application.routes.url_helpers.poll_path(self))
  end

  private

  # validation to ensure an anonymous poll cannot be made un-anonymous
  def cannot_unanon_poll
    if (anon_was == true) and anon_changed?
      # can't do that
      errors.add :anon, 'Cannot make an anonymous poll non-anonymous'
    end
  end
end
