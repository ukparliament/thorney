require_relative './path_manager'

class FixtureSweeper
  def initialize(path_manager = PathManager)
    @path_manager = path_manager.new
  end

  def sweep(stdout = $stdout, simulate: false)
    stdout.puts 'Checking for unused fixtures...'

    return stdout.puts 'No unused fixtures were found' if unused_fixtures.empty?

    show_unused_fixtures(stdout)

    if simulate
      stdout.puts 'Run "bundle exec rake sweep" to delete unused fixtures'

      exit(1)
    end

    delete_fixtures
    stdout.puts 'The unused fixtures were deleted'
  end

  private

  attr_reader :path_manager

  def show_unused_fixtures(stdout)
    stdout.puts 'The following unused fixtures were found:'
    stdout.puts

    path_manager.list_paths(unused_fixtures)

    stdout.puts
  end

  def delete_fixtures(file_utils = FileUtils)
    unused_fixtures.each do |path_hash|
      file_utils.remove_dir(path_hash[:path], true)
    end
  end

  def unused_fixtures
    [].tap do |unused|
      specs_and_fixtures.each do |path|
        unused << unused_fixture_hash(check_file(path), reason:  "Could not find fixture usage in spec file #{path[:spec]}") if check_file(path)
      rescue StandardError
        unused << unused_fixture_hash(path_manager.fixture_parent_folder(path), reason: "Could not find associated spec file #{path[:spec]}")
      end
    end
  end

  def unused_fixture_hash(path, reason:)
    { reason: reason, path: path }
  end

  def name_check(path_hash)
    fixture_name = path_hash[:fixture_name].chomp('.yml')
    controller_method = path_hash[:controller_method] if path_hash[:controller_method]

    return "get_fixture('#{controller_method}', '#{fixture_name}')" if controller_method

    "get_fixture('#{fixture_name}')"
  end

  def check_file(path_hash, file = File)
    file = file.open(path_hash[:spec], 'r', &:read)

    path_manager.full_path(path_hash[:fixture_path]) unless file.include?(name_check(path_hash))
  end

  def specs_and_fixtures
    spec_and_fixtures = []

    Find.find('spec/fixtures') do |path|
      return Find.prune if path.split('/')[2] == 'vcr_cassettes'

      spec_and_fixtures << path_manager.spec_and_fixture(path) if path =~ /.*\.yml$/
    end

    spec_and_fixtures
  end
end
