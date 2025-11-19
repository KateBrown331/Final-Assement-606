class CompanyVerificationsController < ApplicationController
  before_action :require_login

  def new
    @company_verification = CompanyVerification.new
  end

  def create
    @company_verification = current_user.company_verifications.build(company_verification_params)

    unless domain_matches_company?(@company_verification)
      @company_verification.errors.add(:company_email, "must use your company domain (e.g., name@company.com)")
      return render :new
    end

    if @company_verification.save
      CompanyVerificationMailer.verify_email(@company_verification).deliver_later
      redirect_to @company_verification, notice: "A verification email has been sent to your company email."
    else
      render :new
    end
  end

  def show
    @company_verification = CompanyVerification.find(params[:id])
  end

  def verify
    verification = CompanyVerification.find(params[:id])

    if verification.verification_token == params[:token]
      verification.update(is_verified: true, verified_at: Time.current)
      redirect_to user_path(verification.user), notice: "Company email successfully verified!"
    else
      redirect_to root_path, alert: "Invalid or expired verification link."
    end
  end

  private

  def company_verification_params
    params.require(:company_verification).permit(:company_name, :company_email)
  end

  def domain_matches_company?(verification)
    email_domain = verification.company_email.split("@").last.downcase
    company_domain = verification.company_name.parameterize.gsub("-", "")
    email_domain.include?(company_domain)
  end
end
