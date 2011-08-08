class LocationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:public, :vote]
  # GET /locations
  # GET /locations.xml
  def index
    @locations = Location.all
    if @locations.size == 0
      @location = Location.new
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @location }
    end
  end
  
  #public url displaying the survey
  def public
    @location = Location.find(params[:id])
    @survey = @location.survey
    @answers = @survey.answers
    render :layout => 'public_layout'
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
    @surveys = Survey.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @location }
    end
  end

  # GET /locations/1/edit
  def edit
    @location = Location.find(params[:id])
    @surveys = Survey.all
    
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
