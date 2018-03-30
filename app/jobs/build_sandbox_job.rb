class BuildSandboxJob < ApplicationJob
  queue_as :default

  def perform(sandbox)
    Dir.mktmpdir("rbox") do |dir|
      Rugged::Repository.clone_at(sandbox.git_repository_url, dir)
      image = Docker::Image.build_from_dir(dir)
      # implies tag: 'latest'
      image.tag(repo: sandbox.docker_registry_name, force: true)
      image.push
    end
  end
end
