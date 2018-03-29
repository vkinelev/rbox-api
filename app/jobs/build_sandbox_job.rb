class BuildSandboxJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    sandbox = args.first
    tmp_dir = "/tmp/rbox-repositories"

    git_clone_cmd = ""
    git_base_url = 'http://git-server:3000/git'
    git_repo_name = "#{sandbox.name}.git"
    git_repo_url = "#{git_base_url}/#{git_repo_name}"
    git_tmp_repo_directory = "/tmp/rbox-repositories/#{sandbox.name}"

    output = `git clone "#{git_repo_url}" "#{git_tmp_repo_directory}"`

    if $?.exitstatus != 0
      raise "Unable to clone git repository #{git_repo_url}: #{output}" 
    end

    FileUtils.rm_rf(git_tmp_repo_directory)
  end
end
