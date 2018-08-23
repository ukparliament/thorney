# The methods in this module can be used in serializer test to help manage the fixture folders.
module SerializerFixtureHelper
  # This method is used to retrieve the contents of the fixture file for comparison in the test.
  def get_fixture(filename)
    File.open("#{infer_fixture_directory(caller_locations.first.path)}/#{filename}.yml", 'r') { |f| f.read }
  end

  # This method is inserted into a test to create or update a fixture. Make sure to place it on the line above the get_fixture method, and delete once the tests have been run once. 
  def create_fixture(serializer, filename)
    FileUtils::mkdir_p(infer_fixture_directory(caller_locations.first.path))

    File.open("#{infer_fixture_directory(caller_locations.first.path)}/#{filename}.yml", 'w') { |f| p f.write serializer.to_yaml }
  end

  private

  def infer_fixture_directory(path)
    path = path.chomp('_spec.rb').split('/')

    spec_index = path.rindex('spec')

    path.insert(spec_index + 1, 'fixtures').join('/')
  end
end
