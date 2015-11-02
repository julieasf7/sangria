class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :show_modal, :edit, :edit_modal, :update, :destroy]
  before_filter :logged_in?

  # GET /applications
  # GET /applications.json
  def index
    @applications = Application.all
  end

  # GET /applications/1
  # GET /applications/1.json
  def show
    @board = Board.find(@application.board_id)
    @interactions = @application.interactions
  end

  # GET /applications/1/show_modal
  # GET /applications/1/show_modal.json
  def show_modal
    @category = Application::CATEGORIES[@application.category]
    @stage = Board::STAGES[@application.stage-1]
    @company = Company.find(@application.company_id)
    @job = @application.job_id
    @interactions = @application.interactions.order(date: :desc)
    render 'show', :layout => nil
  end

  # GET /applications/new
  def new
    @application = Application.new
    @user = current_user
    @jobs = @user.jobs
    @categories = Application::CATEGORIES
    @companies = Company.all.to_json
    @company = Company.new
  end

  # GET /applications/1/edit
  def edit
  end

  # GET /applications/1/edit_modal
  # GET /applications/1/edit_modal.json
  def edit_modal
    render 'edit', :layout => nil
  end

  # POST /applications
  # POST /applications.json
  def create
    @board = Board.find(application_params[:board_id])

    @user = current_user

    logger.info(company_params)

    new_application_params = {}
    application_params.each do |key, value|
      new_application_params[key] = value
    end
    # TODO: if statement for if creation or company_id
    
    if application_params[:company_id].blank?
      @company = @user.companies.create(company_params)
      new_application_params[:company_id] = @company.id
    end
    
    @application = @board.applications.create(new_application_params)

    respond_to do |format|
      if @application.save
        format.html { redirect_to :back }
        format.json { render :index, status: :created, location: @board }
      else
        format.html { render :new }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /applications/1
  # PATCH/PUT /applications/1.json
  def update
    respond_to do |format|
      if @application.update(application_params)
        format.html { redirect_to :back }
        format.json { render :show, status: :ok, location: @application }
      else
        format.html { render :edit }
        format.json { render json: @application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /applications/1
  # DELETE /applications/1.json
  def destroy
    #TODO: destroy method destroys user and board too. What's going on?
    @application.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def application_params
      params.require(:application).permit(:company_id, :board_id, :job_id, :stage, :category, :settings, :applied_date)
    end

    def company_params
      params.require(:company).permit(:name, :location, :website, :logo)
    end
end
