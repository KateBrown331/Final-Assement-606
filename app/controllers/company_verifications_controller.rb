class CompanyVerificationsController < ApplicationController
  before_action :set_company_verification, only: %i[ show edit update destroy ]

  # GET /company_verifications or /company_verifications.json
  def index
    @company_verifications = CompanyVerification.all
  end

  # GET /company_verifications/1 or /company_verifications/1.json
  def show
  end

  # GET /company_verifications/new
  def new
    @company_verification = CompanyVerification.new
  end

  # GET /company_verifications/1/edit
  def edit
  end

  # POST /company_verifications or /company_verifications.json
  def create
    @company_verification = CompanyVerification.new(company_verification_params)

    respond_to do |format|
      if @company_verification.save
        format.html { redirect_to @company_verification, notice: "Company verification was successfully created." }
        format.json { render :show, status: :created, location: @company_verification }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company_verification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /company_verifications/1 or /company_verifications/1.json
  def update
    respond_to do |format|
      if @company_verification.update(company_verification_params)
        format.html { redirect_to @company_verification, notice: "Company verification was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @company_verification }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company_verification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /company_verifications/1 or /company_verifications/1.json
  def destroy
    @company_verification.destroy!

    respond_to do |format|
      format.html { redirect_to company_verifications_path, notice: "Company verification was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_verification
      @company_verification = CompanyVerification.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def company_verification_params
      params.expect(company_verification: [ :company_email, :company_name, :is_verified, :verification_token ])
    end
end
