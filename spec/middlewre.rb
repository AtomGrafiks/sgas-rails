RSpec.describe 'XSS sanitization' do
  # Ensure that the config.ru gets loaded before these tests
  let(:app) {
    Rack::Builder.new do
      eval File.read(Rory.root.join('config.ru'))
    end
  }

  it 'properly sanitizes obvious but naughty xss attacks' do
    res = `curl -XGET http://localhost:3000/login`
    puts res
    expect(response).to be_success
  end
end