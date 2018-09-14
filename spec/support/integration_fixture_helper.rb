module IntegrationFixtureHelper
  SENSITIVE_DATA = {
    ENV['PARLIAMENT_BASE_URL'] => 'http://localhost:3030'
  }.freeze

  def get_fixture(controller_method, filename)
    File.open("#{directory_name(caller_locations.first.path, controller_method)}/#{filename}.yml", 'r') { |f| f.read }
  end

  def create_fixture(response_body, controller_method, filename)
    FileUtils::mkdir_p(directory_name(caller_locations.first.path, controller_method))

    File.open("#{directory_name(caller_locations.first.path, controller_method)}/#{filename}.yml", 'w') { |f| p f.write JSON.parse(response_body).to_yaml }
  end

  def filter_sensitive_data(response_body)
    SENSITIVE_DATA.each do |sensitive_data, replacement|
      response_body.gsub!(sensitive_data, replacement) if response_body.include?(sensitive_data)
    end

    response_body
  end

  private

  def infer_fixture_directory(path)
    path = path.chomp('_spec.rb').split('/')

    spec_index = path.rindex('spec')

    path[spec_index + 1] = 'fixtures'

    path.join('/')
  end

  def directory_name(path, controller_method)
    "#{infer_fixture_directory(path)}/#{controller_method}"
  end
end
