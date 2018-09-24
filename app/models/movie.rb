class Movie < ActiveRecord::Base
    # Static method to fetch all unique ratings
    def self.getRating
        self.uniq.pluck(:rating)
    end
    
    # Static method tp fecth movie with specific ratings
    def self.getMoviesWithRatings ratings
       self.where(rating: ratings) 
    end
end
