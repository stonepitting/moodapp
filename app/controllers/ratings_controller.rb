require 'csv'

class RatingsController < ApplicationController
  before_filter :authenticate_user!, :except => [:create]
  # GET /ratings
  # GET /ratings.xml
  def index
    @survey = Survey.find(params[:survey_id])

    @locations = current_user.locations
    location_filter = params[:location]
    
    if location_filter && !location_filter.empty?
      location_query = ["location_id = ?", location_filter]
      @location_filter = Location.find(location_filter)
    else
      location_filter = ''
      @location_filter = nil
    end
    
    @ratings = @survey.ratings.includes(:location).where(location_query)
    @ratingsjson = @survey.ratings.all(:include => :location)
    
    # Graph data calculation
    # Setting up the horizontal axis 
    
    # location array
    @loc_array = {}
    # use for percentage
    @loc_array_total = {}
    @locations.each do |l|
      # loc_array format loc_array[location.id] = {location, total # of ratings for the location}
      @loc_array[l.id] = l.name
      @loc_array_total[l.id] = 0
    end
    
    #structure of a score: @score[1] = {sydney => 10, sf => 203}
    @scores = []
    
    #should not be used anymore
    #total = @ratings.length; # use to convert results into percentages
    
    @haxis_label = ['very bad', 'bad', 'neutral', 'good', 'very good'] # haxis legend
    
    #setting all the base score to 0
    @haxis_label.each_with_index{|v, i|
      @scores[i] = {}
    }
    
    # setting up the scores
    @ratings.each do |rating|
        @loc_array_total[rating.location_id] += 1
       if @scores[(rating.label.to_i)][@loc_array[rating.location_id]].nil?
         @scores[(rating.label.to_i)][@loc_array[rating.location_id]] = 1
       else
         @scores[(rating.label.to_i)][@loc_array[rating.location_id]] += 1 
       end
    end
    
    # normalizing the scores through percentages
    #@scores.map!{|s| (s.to_f / total * 100).to_i}
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ratings }
      format.json { render :json => @ratingsjson}
       format.xlsx {
         send_data Rating.to_xlsx.to_stream.read, :filename => 'ratings.xlsx', :type => "application/vnx.openxmlformates-officedocument.spreadsheetml.sheet"
        }      
     end
  end

  # GET /ratings/1
  # GET /ratings/1.xml
  def show
    @rating = Rating.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @rating }
             
    end
  end

  # GET /ratings/new
  # GET /ratings/new.xml
  def new
    @rating = Rating.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @rating }
    end
  end

  # GET /ratings/1/edit
  def edit
    @rating = Rating.find(params[:id])
  end

  # POST /ratings
  # POST /ratings.xml
  def create
    @rating = Rating.new(params[:rating])

    if request.xhr?
      if @rating.save
        head :created
      else
        head 500
      end
    else
      
      respond_to do |format|
        if @rating.save
          format.html { redirect_to(@rating, :notice => 'Rating was successfully created.') }
          format.xml  { render :xml => @rating, :status => :created, :location => @rating }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /ratings/1
  # PUT /ratings/1.xml
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        format.html { redirect_to(@rating, :notice => 'Rating was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.xml
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.html { redirect_to(ratings_url) }
      format.xml  { head :ok }
    end
  end
end
