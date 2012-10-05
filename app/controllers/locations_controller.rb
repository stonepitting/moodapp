class LocationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:public, :vote, :stats, :options]
  # GET /locations
  # GET /locations.xml
  def index
    @locations = current_user.locations.paginate(:page => params[:page], :per_page => 20)
    if @locations.size == 0
      @location = Location.new
    end
    @surveys = current_user.surveys
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  


  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])
    @surveys = current_user.surveys

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end
  
  #public url displaying the survey
  def public
    @location = Location.find(params[:id])
    @survey = @location.survey
    @ratings_count = Rating.find_by_sql("select count(id) as ratings_count from ratings where survey_id = #{@survey.id}")
    render :layout => 'public_layout'
  end
  
  def options
    
    r =  Random.rand(8).to_i
    puts '=============='
    puts r
    @easter_egg = false
    if r == 0 || r == 2
      name = ['Eli', 'Courtney', 'Verity']
      state = [', you rock.', ', you\'re the bomb.', ', you got Swag.', ', I love you.', ', I owe you.']
      signature = [' True story.', ' Ain\'t lyin\'.', ' <3', ' xoxo']
      name_word = name[Random.rand(name.size)]
      state_word = state[Random.rand(state.size)]
      signature_word = signature[Random.rand(signature.size)]
      @phrase = "Yo " + name_word + state_word + signature_word
      @easter_egg = true
    end
    if r == 1
      phrase = ["Is Tony tryin' to take my spot? WTF", "No one loves you like me Tony...", "Who's that Tony guy anyway?"]
      @phrase = phrase[Random.rand(phrase.size)]
      @easter_egg = true
    end
    @location = Location.find(params[:id])
    @survey = @location.survey
    respond_to do |format|
      format.html { render :partial => "options", :layout => false }
    end
  end
  
  # Get and display stats
  
  def stats
    @location = Location.find(params[:id])
    @survey = @location.survey
    
    all_ratings = Rating.find_by_sql("select count(id) as rating_count, label from ratings where survey_id = #{@survey.id} group by label")
    @ratings = {}
    @max = 0
    @total = 0
    all_ratings.each do |r|
      @ratings[r.label] = r.rating_count.to_i
      if r.rating_count.to_i > @max
        @max = r.rating_count.to_i
      end
      @total += r.rating_count.to_i
    end
    if request.xhr?
      render :partial => 'stats_ajax'
    else
   
    end
    
  end
  
  #register a vote
  def vote
    location = Location.find(params[:id])
    answer = Answer.find(params[:answer_id])
    survey = location.survey
    vote = Vote.new({:survey_id => survey.id, :location_id => location.id, :answer_id => answer.id, :ip => request.remote_ip})
    vote.save
    location.increment(:votes_count)
    location.save
    answer.increment(:votes_count)
    answer.save
    survey.increment(:votes_count)
    survey.save
    
    head :ok
    
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @location = Location.new
    @surveys = current_user.surveys
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    @surveys = current_user.surveys
    
  end

  # POST /locations
  # POST /locations.xml
  def create
    @location = Location.new(params[:location])
    @location.user = current_user
    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @location = Location.find(params[:id])

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.xml  { head :ok }
    end
  end
end
