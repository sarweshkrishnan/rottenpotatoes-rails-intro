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
    # Get all params passed in the request
    @order = params[:order]
    ratings = params[:ratings]
    
    # Get all movie ratings
    allMovieRating = Movie.getRating
    
    # Check all ratings incase request without ratings param
    if ratings == nil
      ratings = Hash.new
      allMovieRating.each do |ratingValue|
        ratings[ratingValue] = "1"
      end
    end
    
    # Fill @all_ratings hash key="rating" val = boolean
    @all_ratings = Hash.new
    allMovieRating.each do |ratingValue|
      if ratings[ratingValue] == "1"
        @all_ratings[ratingValue] = true
      else
        @all_ratings[ratingValue] = false
      end
    end
    
    # Check order param for any ordering required
    if @order == "title"
      @movies = Movie.order(:title)
    elsif  @order == "date"
      @movies = Movie.order(:release_date)
    else
      @movies = Movie.getMoviesWithRatings(ratings.keys)
    end
    
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
