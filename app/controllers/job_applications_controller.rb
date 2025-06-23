class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: [:show, :edit, :update, :destroy]

  def index
    @job_applications = JobApplication.includes(:application_status, :tech_stacks).ordered
    @application_statuses = ApplicationStatus.ordered
    @tech_stacks = TechStack.order(:name)
  end

  def show
  end

  def new
    @job_application = JobApplication.new
    @application_statuses = ApplicationStatus.ordered
    @tech_stacks = TechStack.order(:name)
  end

  def create
    @job_application = JobApplication.new(job_application_params)
    if @job_application.save
      redirect_to job_applications_path, notice: 'Job application was successfully created.'
    else
      @application_statuses = ApplicationStatus.ordered
      @tech_stacks = TechStack.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @application_statuses = ApplicationStatus.ordered
    @tech_stacks = TechStack.order(:name)
  end

  def update
    if @job_application.update(job_application_params)
      respond_to do |format|
        format.html { redirect_to job_applications_path, notice: 'Job application was successfully updated.' }
        format.json { render json: { success: true, message: 'Job application was successfully updated.' } }
      end
    else
      respond_to do |format|
        format.html do
          @application_statuses = ApplicationStatus.ordered
          @tech_stacks = TechStack.order(:name)
          render :edit, status: :unprocessable_entity
        end
        format.json { render json: { success: false, error: @job_application.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @job_application.destroy
    redirect_to job_applications_path, notice: 'Job application was successfully deleted.'
  end

  # AJAX endpoints for managing statuses and tech stacks
  def create_status
    @status = ApplicationStatus.new(name: params[:name])
    if @status.save
      render json: { id: @status.id, name: @status.name }
    else
      render json: { error: @status.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def create_tech_stack
    @tech_stack = TechStack.new(name: params[:name])
    if @tech_stack.save
      render json: { id: @tech_stack.id, name: @tech_stack.name }
    else
      render json: { error: @tech_stack.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def job_application_params
    params.require(:job_application).permit(:date_applied, :company_name, :job_link, :tech_stack_names, :application_status_id)
  end
end 