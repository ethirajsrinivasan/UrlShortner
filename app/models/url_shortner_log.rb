class UrlShortnerLog < ApplicationRecord
	
	#Relationship
	belongs_to :user
	belongs_to :url_shortner

end