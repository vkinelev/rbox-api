class Sandbox < ApplicationRecord
  validates :name, presence: true

  before_validation :generate_name

  after_create :setup_git_repository
  after_create_commit :enqueue_build_and_deploy

  def generate_name
    self.name = SecureRandom.base58(24).downcase
  end

  def setup_git_repository
    unless File.exist?(path_to_git_repository)
      FileUtils.mkdir_p(path_to_git_repository)
      path_to_tmpl = File.join(path_to_template_git_repository, '.')
      p path_to_tmpl, path_to_git_repository
      FileUtils.cp_r(path_to_tmpl, path_to_git_repository)
    end

    dest_hooks_dir = File.join(path_to_git_repository, 'hooks')
    p FileUtils.cp(Rails.root.join('post-receive'), dest_hooks_dir)
  end

  def enqueue_build_and_deploy
    BuildAndDeploySandboxJob.perform_later(self)
  end

  def git_repository_url
    [ENV['GIT_BASE_URL'], git_repository_basename].join('/')
  end

  def docker_registry_name
    [ENV['DOCKER_REGISTRY_URL'], name].join('/')
  end

  def app_url
    ENV['BASE_HOST_FOR_SANDBOXES'] + ":#{app_port}"
  end

  def docker_service_options
    service_create_options = {"Name"=> name,
     "TaskTemplate" => {
       "ForceUpdate" => 1,
       "ContainerSpec" => {
         "Networks" => [],
         "Image" => docker_registry_name,
         "Mounts" => [],
         "User" => "root"
       },
       "Env" => [
         "RAILS_ENV=development"
       ],
       "LogDriver" => {
         "Name" => "json-file",
         "Options" => {
           "max-file" => "3",
           "max-size"=>"10M"
         }
       },
       "Resources" => {
         "Limits" => {
           "MemoryBytes" => 104857600
         },
         "Reservations" => {}
       },
       "RestartPolicy" => {
         "Condition" => "on-failure",
         "Delay"=>1,
         "MaxAttempts"=>3
       }
     },

     "Mode"=> {
       "Replicated" => {
         "Replicas" => 1
       }
     },
     "UpdateConfig" => {
       "Delay" => 2,
       "Parallelism" => 2,
       "FailureAction" => "pause"
     },
     "EndpointSpec"=> {
        "Ports" => [
          {
            "Protocol"=>"http",
            "PublishedPort" => app_port,
            "TargetPort" => 3000
          }
        ]
      },
    }
  end

  private

    def path_to_template_git_repository
      File.join(ENV['TEMPLATES_DIR'], 'sample-rails-app-sqlite.git')
    end

    def path_to_git_repository
      File.join(ENV['GIT_DIR'], git_repository_basename)
    end

    def git_repository_basename
      "#{name}.git"
    end

    def app_port
      3000 + id
    end
end
