class Label < ActiveRecord::Base
  validates_presence_of :name, unique: true
end
