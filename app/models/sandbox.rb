class Sandbox < ApplicationRecord

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

    def git_repository_basename
      "#{name}.git"
    end

    def app_port
      3000 + id
    end
end
