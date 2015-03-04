class Company < ActiveRecord::Base
  validates :name, presence: true
  include Contact

  def to_s
    "#{name}"
  end
end
