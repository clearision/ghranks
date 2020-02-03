class Report < ActiveRecord::Base
  enum state: %w(created ready)

  serialize :result

  validates :repo, presence: true, uniqueness: true
end
