module SerializerFixtureHelper
  def get_fixture(filename)
    File.open("#{infer_fixture_directory(caller_locations.first.path)}/#{filename}.yml", 'r') { |f| f.read }
  end

  def create_fixture(serializer, filename)
    FileUtils::mkdir_p(infer_fixture_directory(caller_locations.first.path))

    File.open("#{infer_fixture_directory(caller_locations.first.path)}/#{filename}.yml", 'w') { |f| p f.write serializer.to_yaml }
  end

  private

  def infer_fixture_directory(path)
    path = path.chomp('_spec.rb').split('/')
    path = path.insert(path.length - 3, 'fixtures').join('/')
    path
  end
end