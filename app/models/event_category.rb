# encoding: utf-8

class EventCategory < ActiveRecord::Base
  has_many :event_category_prices, dependent: :destroy
  has_many :events

  validates_presence_of :title, :abbrv, :sort_order, :color
  validates_uniqueness_of :title, :abbrv

  scope :active, -> { where(active: true) }
  default_scope order('sort_order asc')
end
