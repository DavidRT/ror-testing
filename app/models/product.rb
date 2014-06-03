class Product < ActiveRecord::Base
#default_scope se aplica a todas las querys que comienzen con este modelo.
default_scope :order => 'title'

validates :title,:description,:image_url, presence: {message: 'must be unique. Show some originality!'} 
#validates_length_of :title, :minimum => 10, :message => "at least 10 characteres" # :too_short
validates :title, :length => {:minimum => 10, :message => "at least 10 characteres"}
validates :price, :numericality => {:greater_than_or_equal_to => 0.01}
validates :title, :uniqueness => true
validates :image_url, :format => {
	:with 	 => %r{\.(gif|jpg|png)\z}i,
	:message => "must be a URL for GIF, JPG or PNG image." }
	
end
