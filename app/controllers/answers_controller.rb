class AnswersController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  # GET /answers
  # GET /answers.xml
  def index
    cond = {}
    
    if params[:survey_id]
      cond = {:survey_id => params[:survey_id]}
    end
    if params[:location_id]
      @location = Location.find(params[:location_id])
      @survey = @location.survey
      cond = {:survey_id => @survey.id}
    end
    @answers = Answer.all(:conditions => cond)

    if request.xhr?
      render :partial => 'index_ajax'
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @answers }
      end
    end
  end

  # GET /answers/1
  # GET /answers/1.xml
  def show
    @answer = Answer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/new
  # GET /answers/new.xml
  def new
    @answer = Answer.new
    @survey = Survey.find(params[:survey_id])
    @answer.survey_id = @survey.id

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @answer }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  # POST /answers.xml
  def create
    @answer = Answer.new(params[:answer])
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        format.html { redirect_to(@answer.survey, :notice => 'Answer was successfully created.') }
        format.xml  { render :xml => @answer, :status => :created, :location => @answer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.xml
  def update
    @answer = Answer.find(params[:id])

    respond_to do |format|
      if @answer.update_attributes(params[:answer])
        format.html { redirect_to(@answer.survey, :notice => 'Answer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @answer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.xml
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to(answers_url) }
      format.xml  { head :ok }
    end
  end
end
