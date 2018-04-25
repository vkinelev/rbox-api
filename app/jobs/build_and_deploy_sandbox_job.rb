class BuildAndDeploySandboxJob < ApplicationJob
  queue_as :default

  def perform(sandbox)
    image = nil
    Dir.mktmpdir("rbox") do |dir|
      Rugged::Repository.clone_at(sandbox.git_repository_url, dir)
      image = Docker::Image.build_from_dir(dir)
      # implies tag: 'latest'
      image.tag(repo: sandbox.docker_registry_name, force: true)
      image = image.push(nil)
    end
    p image = Docker::Image.get(image.id)

    docker_connection =
      Docker::Swarm::Connection.new(Docker.url, Docker.options)

    swarm = Docker::Swarm::Swarm.find(docker_connection)
    begin
      service = swarm.find_service(sandbox.name)
      service.update(sandbox.docker_service_options(image.info['RepoDigests'].first))
    rescue Excon::Error::NotFound
      swarm.create_service(sandbox.docker_service_options(image.info['RepoDigests'].first))
    end
  end
end
