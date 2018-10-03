RSpec.shared_context "sample request", :shared_context => :metadata do
  let(:request) do
    request = ActionDispatch::TestRequest.create({ 'ApplicationInsights.request.id' => 123456 })
    request.host = 'example.com'

    request
  end

  subject { described_class.new(request: request) }
end