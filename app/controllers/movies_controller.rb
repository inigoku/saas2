class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] 
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      params[:ratings] = session[:ratings]
      @redirect = true
    else
      params[:ratings] = Hash.new
      Movie.all_ratings.each { |rating| params[:ratings][rating] = "1" }
      @redirect = true
    end
    
    if params[:sortby] 
      session[:sortby] = params[:sortby]
    elsif session[:sortby]
      params[:sortby] = session[:sortby]
      @redirect = true
    else
      params[:sortby] = "title"
      @redirect = true
    end

    if (@redirect)
      flash.keep
      redirect_to movies_path(params)
    end
      
    @movies = Movie.find_all_by_rating(params[:ratings].keys, :order => params[:sortby])
    @ratings = params[:ratings]
    @sortby = params[:sortby]
    @all_ratings = Movie.all_ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
