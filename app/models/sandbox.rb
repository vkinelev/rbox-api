class Sandbox < ApplicationRecord

  def git_repository_url
    [ENV['GIT_BASE_URL'], git_repository_basename].join('/')
  end

  def docker_registry_name
    [ENV['DOCKER_REGISTRY_URL'], name].join('/')
  end

  private

    def git_repository_basename
      "#{name}.git"
    end
end
