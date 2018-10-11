class PathManager
  def fixture_parent_folder(path_hash)
    parent_folder = path_hash[:fixture_path].split('/')
    parent_folder.pop
    parent_folder = parent_folder.join('/')

    full_path(parent_folder + '/')
  end

  def spec_and_fixture(path)
    return controller_spec_and_fixture(path) if controller_fixture?(path)

    generic_spec_and_fixture(path)
  end

  def full_path(path)
    root = __dir__.chomp('app/services')

    root + path
  end

  def list_paths(paths, stdout: $stdout)
    paths.each do |path|
      stdout.puts path
    end
  end

  private

  def generic_spec_and_fixture(path)
    spec_fixture_hash(spec_path(path), fixture_name(path), path)
  end

  def controller_spec_and_fixture(path)
    spec_fixture_hash(controller_spec_path(path), fixture_name(path), path, controller_method: controller_method(path))
  end

  def controller_fixture?(path)
    path.split('/')[2] == 'controllers'
  end

  def controllers_index(split_path)
    split_path.find_index('controllers')
  end

  # Returns the controller method when given a path to a fixture file
  # Either returns the method or nil if it is not a controller spec (it may be in the controllers folder, for example, a helper)
  #
  # @example Controller fixture passed in
  #   path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'
  #   controller_method(path) #=> 'index'
  #
  # @example Helper fixture passed in
  #   path = 'spec/fixtures/controllers/concerns/pagination_helper/create_number_cards.yml'
  #   controller_method(path) #=> nil
  #
  # @param [String] path A path to fixture file
  # @return [String, nil] The controller method or nil
  def controller_method(path)
    split_path = path.split('/')

    split_path[split_path.length - 2] if controller_spec?(path)
  end

  def controller_spec?(path)
    path.include?('_controller')
  end

  # Returns the path to the spec file when given a fixture path
  # It either returns the path to the integration tests for a controller or unit tests for a class in app/controllers
  #
  # @example Controller fixture passed in
  #   path = 'spec/fixtures/controllers/groups_controller/index/fixture.yml'
  #   controller_spec_path(path) #=> root + 'spec/integration/controllers/groups_controller_spec.rb'
  #
  # @example Other type of fixture within controllers
  #   path = 'spec/fixtures/controllers/concerns/pagination_helper/create_number_cards.yml'
  #   controller_spec_path(path) #=> root + 'spec/controllers/concerns/pagination_helper_spec.rb'
  #
  # @param [String] path A path to a fixture file
  # @return [String] The path to the associated spec file
  def controller_spec_path(path)
    path = (path.split('/') - ['fixtures']).join('/')

    split_path = full_path(path).split('/')

    if controller_spec?(path)
      split_path = split_path[0..split_path.length - 3]
      split_path.insert(controllers_index(split_path), 'integration')
    else
      split_path.pop
    end

    split_path.join('/') + '_spec.rb'
  end

  # Returns the path to the spec file when given a fixture path for non-controller tests
  #
  # @example Fixture passed in
  #   path = 'spec/fixtures/serializers/component_serializer/card_component_serializer/fixture.yml'
  #   spec_path(path) #=> root + 'spec/serializers/component_serializer/card_component_serializer_spec.rb'
  #
  # @param [String] path A path to a fixture file
  # @return [String] The path to the associated spec file
  def spec_path(path)
    path = (path.split('/') - ['fixtures']).join('/')
    split_path = full_path(path).split('/')

    split_path.pop
    split_path.join('/') + '_spec.rb'
  end

  def fixture_name(path)
    path.split('/').last
  end

  def spec_fixture_hash(spec, fixture_name, fixture_path, controller_method: nil)
    {}.tap do |hash|
      hash[:spec] = spec
      hash[:fixture_name] = fixture_name
      hash[:fixture_path] = fixture_path
      hash[:controller_method] = controller_method if controller_method
    end
  end
end
