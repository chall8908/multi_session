RSpec.describe 'Railtie Configuration' do
  it 'latches configuration from Rails.configuration' do
    expect(MultiSession.expires).to eq(Rails.configuration.multi_session.expires)
    expect(MultiSession.domain).to eq(Rails.configuration.multi_session.domain)

    # This should have been automatically set in the Railtie
    expect(MultiSession.credentials_strategy).to eq :credentials
  end
end
