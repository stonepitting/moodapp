class SurveysController < ApplicationController
  before_filter :authenticate_user!, :except => [:stats, :options]
  # GET /surveys
  # GET /surveys.xml
  def index
    @surveys = current_user.surveys

    if @surveys.size == 0
      @survey = Survey.new
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surveys }
    end
  end

  # GET /surveys/1
  # GET /surveys/1.xml
  def show
    @survey = Survey.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end
  
  def options
    @survey = Survey.find(params[:id])
    
    respond_to do |format|
      format.html { render :partial => "options", :layout => false }
    end
  end
  
  # Get and display stats
  
  def stats
    @survey = Survey.find(params[:id])
  
  
    all_ratings = Rating.find_by_sql("select count(id) as rating_count, label from ratings where survey_id = #{@survey.id} group by label")
    @ratings = {}
    @max = 0
    @total = 0
    all_ratings.each do |r|
      @ratings[r.label] = r.rating_count
      if r.rating_count > @max
        @max = r.rating_count
      end
      @total += r.rating_count
    end
    puts @total
    puts @ratings
    if request.xhr?
      render :partial => 'stats_ajax'
    else
   
    end
    
  end
  
  def stats_all
    @survey = Survey.find(params[:id])
    @answers = @survey.answers

    @votes = @survey.votes
    
  end
  
  # GET /surveys/new
  # GET /surveys/new.xml
  def new
    @survey = Survey.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @survey }
    end
  end

  # GET /surveys/1/edit
  def edit
    @survey = Survey.find(params[:id])
  end

  # POST /surveys
  # POST /surveys.xml
  def create
    @survey = Survey.new(params[:survey])
    @survey.user = current_user
    respond_to do |format|
      if @survey.save
        format.html { redirect_to(@survey, :notice => 'Survey was successfully created.') }
        format.xml  { render :xml => @survey, :status => :created, :location => @survey }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surveys/1
  # PUT /surveys/1.xml
  def update
    @survey = Survey.find(params[:id])

    respond_to do |format|
      if @survey.update_attributes(params[:survey])
        format.html { redirect_to(@survey, :notice => 'Survey was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @survey.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surveys/1
  # DELETE /surveys/1.xml
  def destroy
    @survey = Survey.find(params[:id])
    @survey.destroy

    respond_to do |format|
      format.html { redirect_to(surveys_url) }
      format.xml  { head :ok }
    end
  end
end
