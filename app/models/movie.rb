class Movie < ActiveRecord::Base
    # Static method to fetch all unique ratings
    def self.getRating
        self.uniq.pluck(:rating)
    end
    
    # Static method tp fecth movie with specific ratings
    def self.getMoviesWithRatings ratings, order
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
