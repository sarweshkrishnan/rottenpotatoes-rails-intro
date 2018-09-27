class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    # Get unique movie ratings from db
    allMovieRating = Movie.getRating
    
    # Check request for ratings param
    if params.has_key?(:ratings)
      ratings = params[:ratings]
    else
      ratings = Hash.new
      # If we have a session variable
      if session[:ratings]
        sessionRatings = session[:ratings]
        sessionRatings.keys.each do |key|
          if sessionRatings[key]
            ratings[key] = "1"
          end
        end
      # Incase of no session and no params
      else
        allMovieRating.each do |key|
          ratings[key] = "1"
        end
      end
    end
    
    # Fill @all_ratings hash key="rating" val = boolean
    all_ratings = Hash.new
    allMovieRating.each do |key|
        all_ratings[key] = ratings[key] == "1" ? true : false
    end
    session[:ratings] = all_ratings
    
    # Check order param for any ordering required
    if params.has_key?(:order)
      order = params[:order]
      session[:order] = order
    elsif session[:order]
      order = session[:order]
    end
    
    # For handling redirects - to keep the URIs RESTful
    if (!params.has_key?(:ratings) and !session[:ratings].nil?) or (!params.has_key?(:order) and !session[:order].nil?)
      redirect_to :controller => 'movies', :action => 'index', :ratings => ratings, :order => order
    end
      
    # Call method in movies to fetch the movies in the right order and only specified ratings
    @movies = Movie.getMoviesWithRatings(ratings.keys, order)
  end

  def new
    # default: render 'new' template
  end
 
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
