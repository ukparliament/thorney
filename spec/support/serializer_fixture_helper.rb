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

    spec_index = path.rindex('spec')

    path.insert(spec_index + 1, 'fixtures').join('/')
  end
end