class PollsController < ApplicationController
  # GET /polls
  # GET /polls.xml
  def index
    @polls = Poll.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @polls }
    end
  end

  # GET /polls/1
  # GET /polls/1.xml
  def show
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @poll }
    end
  end

  # GET /polls/new
  # GET /polls/new.xml
  def new
    @poll = Poll.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @poll }
    end
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
  end

  # POST /polls
  # POST /polls.xml
  def create
    @poll = Poll.new(params[:poll])

    respond_to do |format|
      if @poll.save
        format.html { redirect_to(@poll, :notice => 'Poll was successfully created.') }
        format.xml  { render :xml => @poll, :status => :created, :location => @poll }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /polls/1
  # PUT /polls/1.xml
  def update
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        format.html { redirect_to(@poll, :notice => 'Poll was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @poll.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /polls/1
  # DELETE /polls/1.xml
  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to(polls_url) }
      format.xml  { head :ok }
    end
  end
end
