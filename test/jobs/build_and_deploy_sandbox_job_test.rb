require 'test_helper'

class BuildAndDeploySandboxJobTest < ActiveJob::TestCase

  def setup
    # `docker run -d -p 5000:5000 --name registry registry:2`
  end

  def teardown
    # `docker container stop registry && docker container rm -v registry`
  end

  test "the truth" do
    BuildSandboxJob.perform_now(Sandbox.first)
  end
end
