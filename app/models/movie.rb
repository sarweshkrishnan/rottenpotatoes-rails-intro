class Movie < ActiveRecord::Base
    # Class method to fetch all unique ratings
    def self.get_rating
        self.uniq.pluck(:rating)
    end
    
    # Class method tp fetch movie with specific ratings, and ordered
    def self.get_movies_with_ratings ratings, order
        unless order.nil?
            if order == "title"
                return self.order(:title).where(rating: ratings)
            elsif order == "date"
                return self.order(:release_date).where(rating: ratings)
            end
        else
            return self.where(rating: ratings)
        end
    end
end
