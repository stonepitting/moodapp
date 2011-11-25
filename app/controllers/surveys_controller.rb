class SurveysController < ApplicationController
  before_filter :authenticate_user!, :except => :stats
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
    @answers = @survey.answers

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @survey }
    end
  end
  
  # Get and display stats
  
  def stats
    @survey = Survey.find(params[:id])
    @answers = @survey.answers
    
    #@answers = []
    #all_answers.each do |a|
    #  @answers[a.id] = a
    #end
    #@votes = @survey.votes.order('created_at')
    
    all_votes = Vote.find_by_sql('select answer_id, count(id) as nb from votes  group by answer_id ')
    @votes = []
    @max = 0
    @total = 0
    all_votes.each do |v|
      @votes[v.answer_id] = v
      if v.nb > @max
        @max = v.nb
        @total += v.nb
      end
    end
    
    
    #puts '================'
    #puts v.inspect
    #puts v[0].nb
    
    
    
    
=begin    
    @votes = []
    if params[:date]
      @date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
      @votes = @survey.votes.where("YEAR(created_at) = ? and MONTH(created_at) = ?", params[:date][:year], params[:date][:month]).group('answer_id')
      
    else
      @answers = @survey.answers
      if @answers
        @votes = @answers.votes.group('answer_id')
      end
    end
    
    puts '-------------------------------------'
    puts @votes.inspect
    
    if request.xhr?
      
      render :partial => 'stats_ajax'
    else
      
    end
=end
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
