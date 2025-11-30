erDiagram

    Users {
        int id PK
        string email
        string password_digest
        string first_name
        string last_name
        string tamu_verification_token
        boolean is_tamu_verified
        datetime tamu_verified_at
        string headline
        string summary
        string linkedin_url
        string github_url
        json experiences_data
        json educations_data
        datetime created_at
        datetime updated_at
    }

    CompanyVerifications {
        int id PK
        int user_id FK
        string company_email
        string company_name
        string verification_token
        boolean is_verified
        datetime verified_at
        datetime created_at
        datetime updated_at
    }

    ReferralPosts {
        int id PK
        int user_id FK
        int company_verification_id FK
        string title
        string company_name
        string job_title
        string department
        string location
        string job_level
        string employment_type
        json questions
        enum status
        datetime created_at
        datetime updated_at
    }

    ReferralRequests {
        int id PK
        int user_id FK
        int referral_post_id FK
        enum status
        json submitted_data
        string note_to_poster
        datetime created_at
        datetime updated_at
    }

    Conversations {
        int id PK
        int sender_id FK
        int recipient_id FK
        string subject
        datetime created_at
        datetime updated_at
    }

    Messages {
        int id PK
        int conversation_id FK
        int user_id FK
        string body
        boolean read
        datetime created_at
        datetime updated_at
    }

    ActiveStorage {
        -- Active Storage tables (blobs & attachments)
    }

    %% Relationships

    Users ||--o{ CompanyVerifications : "1:N"
    Users ||--o{ ReferralPosts : "1:N"
    Users ||--o{ ReferralRequests : "1:N"
    Users ||--o{ Conversations : "sends"
    Users ||--o{ Conversations : "receives"
    Users ||--o{ Messages : "1:N"

    CompanyVerifications ||--o{ ReferralPosts : "1:N"

    ReferralPosts ||--o{ ReferralRequests : "1:N"

    Conversations ||--o{ Messages : "1:N"

    Users ||--|| ActiveStorage : "has_one resume"