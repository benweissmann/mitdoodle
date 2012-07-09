class PollsController < ApplicationController
  before_filter :find_poll, :except =>  [:index, :new, :create]
  before_filter :require_ownership, :except => [:index, :new, :create, :vote, :show]
  before_filter :require_open, :only => [:vote, :edit]

  # GET /polls
  def index
    redirect_to MITDOODLE_HOME
  end

  # GET /polls/1
  def show
    @counts = @poll.options.map(&:yes_votes_count)
    max = @counts.max
    @counts.map! {|count| [count, count == max]}
    @most_popular = @poll.options.each_with_index.select{|opt, i| @counts[i].last}.map(&:first)

    respond_to do |format|
      format.html # show.html.haml
    end
  end

  # GET /polls/new
  def new
    @poll = Poll.new
    4.times { @poll.options.build }

    respond_to do |format|
      format.html # new.html.haml
    end
  end

  # GET /polls/1/edit
  def edit
    # edit.html.haml
  end

  # POST /polls
  def create
    @poll = Poll.new(params[:poll])
    @poll.user_id = current_user.id
    @poll.key = ActiveSupport::SecureRandom.hex(15)
    @poll.generate_short_link

    respond_to do |format|
      if @poll.save
        flash[:notice] = 'Poll was successfully created.'
        format.html { redirect_to(poll_path(@poll)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /polls/1
  def update
    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        flash[:notice] = 'Poll was successfully updated.'
        format.html { redirect_to(@poll) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # POST /polls/1/vote
  def vote
    success = true
    Vote.transaction do
      @poll.options.each do |opt|
        v = Vote.find_or_create_by_user_id_and_option_id current_user.id, opt.id
        v.yes = (params[opt.id.to_s] == '1')
        unless v.save
          success = false
          raise ActiveRecord::Rollback
        end
      end
    end

    respond_to do |format|
      if success
        flash[:notice] = 'You have successfully voted.'
        format.html { redirect_to(@poll) }
      else
        format.html { render :action => "show" }
      end
    end
  end

  # POST /polls/1/close
  def close
    @poll.closed = true

    if @poll.save
      flash[:notice] = 'Poll has been closed'
    else
      flash[:error] = 'There was an error closing the poll'
    end

    respond_to do |format|
      format.html { redirect_to(poll_path(@poll)) }
    end
  end

  # POST /polls/1/open
  def open
    @poll.closed = false

    if @poll.save
      flash[:notice] = 'Poll has been opened'
    else
      flash[:error] = 'There was an error opening the poll'
    end

    respond_to do |format|
      format.html { redirect_to(poll_path(@poll)) }
    end
  end

  # DELTETE /polls/1/voters/1
  def delete_voter
    @poll.votes.where(:user_id => params[:voter_id]).each {|v| v.destroy}

    respond_to do |format|
      flash[:notice] = 'Vote deleted'
      format.html { redirect_to(poll_path(@poll)) }
    end
  end

  private

  def require_ownership
    unless @poll.user == current_user
      flash[:error] = "You don't have permission to do that"
      redirect_to poll_url(@poll)
    end
  end

  def find_poll
    @poll = Poll.find_by_key(params[:id])
    if @poll.nil?
      flash[:error] = "Invalid poll key"
      redirect_to MITDOODLE_HOME
    end
  end

  def require_open
    if @poll.closed
      flash[:error] = "The poll is closed"
      redirect_to(poll_url(@poll))
    end
  end
end
