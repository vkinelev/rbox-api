class BuildSandboxJob < ApplicationJob
  queue_as :default

  def perform(sandbox)
    Dir.mktmpdir("rbox") do |dir|
      Rugged::Repository.clone_at(sandbox.git_repository_url, dir)
      image = Docker::Image.build_from_dir(dir)
      # implies tag: 'latest'
      image.tag(repo: sandbox.docker_registry_name, force: true)
      image.push(nil)
    end

    docker_connection =
      Docker::Swarm::Connection.new(Docker.url, Docker.options)

    swarm = Docker::Swarm::Swarm.find(docker_connection)
    begin
      service = swarm.find_service(sandbox.name)
      service.restart
    rescue Excon::Error::NotFound
      swarm.create_service(sandbox.docker_service_options)
    end
  end
end
