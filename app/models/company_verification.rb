class CompanyVerification < ApplicationRecord
  # --- 1. Table Relationships ---
  # This model "belongs to" the user model.
  # This is the "child" side of the one-to-many relationship.
  belongs_to :user

  # This model "has many" posts.
  # 'dependent: :restrict_with_error' means you cannot delete a
  # verification if it's still attached to an active post.
  has_many :referral_posts, dependent: :restrict_with_error

  # --- 2. Email Verification ---
  # This handles the token for verifying the *company* email.
  has_secure_token :verification_token

  # --- 3. Validations ---
  validates :company_email, presence: true,
                            # This is a key validation: A user can't add the
                            # same company email twice.
                            uniqueness: { scope: :user_id, message: "has already been registered" },
                            # Checks if it looks like a real email.
                            format: { with: URI::MailTo::EMAIL_REGEXP, message: "is not a valid email" }
  validates :company_name, presence: true
end
