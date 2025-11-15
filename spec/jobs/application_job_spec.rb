require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it 'loads the job base class' do
    expect(defined?(ApplicationJob)).to be_truthy
    expect(ApplicationJob.ancestors).to include(ActiveJob::Base)
  end
end
