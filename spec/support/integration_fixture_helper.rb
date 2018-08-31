module IntegrationFixtureHelper
  def get_fixture(controller_method, filename)
    File.open("#{directory_name(caller_locations.first.path, controller_method)}/#{filename}.yml", 'r') { |f| f.read }
  end

  def create_fixture(response, controller_method, filename)
    FileUtils::mkdir_p(directory_name(caller_locations.first.path, controller_method))

    File.open("#{directory_name(caller_locations.first.path, controller_method)}/#{filename}.yml", 'w') { |f| p f.write response.to_yaml }
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
