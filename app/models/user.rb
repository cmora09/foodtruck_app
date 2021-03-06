class User < ActiveRecord::Base
	has_secure_password
	validates_confirmation_of :password 
	validates_presence_of :password , on: :create

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email , presence: true,uniqueness: {case_sensitive: false},length: {minimum: 4} , format: {with: VALID_EMAIL_REGEX}
	has_many :orders
	has_many :trucks
	
	# This is using the address method to use the attributes of the user model
	# to get a full address as a string. 
	geocoded_by :address
	after_validation :geocode
	# using Obj.geocode gives a longitude latitude coordinates of current location

	def address
		[street_address,city, state, zip, country].compact.join(", ")
	end

	# checks to see if an address has been changed/updated or is present before using geocode
	after_validation :geocode, if: ->(obj){ obj.street_address.present? and obj.state.present? and obj.city.present? and obj.zip.present? and obj.street_address_changed? and obj.state_changed? and obj.city_changed? and obj.zip_changed?}

end
