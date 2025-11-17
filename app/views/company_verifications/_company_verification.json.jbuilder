json.extract! company_verification, :id, :company_email, :company_name, :is_verified, :verification_token, :created_at, :updated_at
json.url company_verification_url(company_verification, format: :json)
