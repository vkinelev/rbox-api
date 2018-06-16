class SandboxesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :deploy, if: :api?
  before_action :set_sandbox, only: [:show, :edit, :update, :destroy, :file_contents]

  # GET /sandboxes
  # GET /sandboxes.json
  def index
    @sandboxes = Sandbox.all
  end

  # GET /sandboxes/1
  # GET /sandboxes/1.json
  def show
    Dir.mktmpdir("rbox") do |dir|
      Rugged::Repository.clone_at(@sandbox.git_repository_url, dir)
      @files = Dir[dir + '/**/*']
        .reject { |f| File.directory?(f) }
        .map { |f| f.sub(dir + '/', '') }
        .sort { |a, b| a.downcase <=> b.downcase }
    end
  end

  def file_contents
    Dir.mktmpdir("rbox") do |dir|
      Rugged::Repository.clone_at(@sandbox.git_repository_url, dir)

      send_data File.read(dir + '/' + params[:filename]), type: 'text/plain', disposition: 'inline'
    end
  end

  def save_changes
    logger.debug params

    Dir.mktmpdir("rbox") do |dir|
      repo = Rugged::Repository.clone_at(@sandbox.git_repository_url, dir)
      index = repo.index
      params[:files].each do |uploaded_file|
        dest = File.join(dir, uploaded_file.file_name)
        FileUtils.cp(
          uploaded_file.tempfile.path,
          dest
        )
        # index.add(uploaded_file.file_name)
      end
    end
  end

  # GET /sandboxes/new
  def new
    @sandbox = Sandbox.new
  end

  # GET /sandboxes/1/edit
  def edit
  end

  # POST /sandboxes
  # POST /sandboxes.json
  def create
    @sandbox = Sandbox.new(sandbox_params)

    respond_to do |format|
      if @sandbox.save
        format.html { redirect_to @sandbox, notice: 'Sandbox was successfully created.' }
        format.json { render :show, status: :created, location: @sandbox }
      else
        format.html { render :new }
        format.json { render json: @sandbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sandboxes/1
  # PATCH/PUT /sandboxes/1.json
  def update
    respond_to do |format|
      if @sandbox.update(sandbox_params)
        format.html { redirect_to @sandbox, notice: 'Sandbox was successfully updated.' }
        format.json { render :show, status: :ok, location: @sandbox }
      else
        format.html { render :edit }
        format.json { render json: @sandbox.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sandboxes/1
  # DELETE /sandboxes/1.json
  def destroy
    @sandbox.destroy
    respond_to do |format|
      format.html { redirect_to sandboxes_url, notice: 'Sandbox was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /sandboxes/gmjs4tw4dk5peypzlavhcpim/deploy
  # POST /sandboxes/gmjs4tw4dk5peypzlavhcpim/deploy.json
  def deploy
    BuildAndDeploySandboxJob.perform_later(Sandbox.find_by_name!(params[:id]))
    respond_to do |format|
      format.html { redirect_to @sandbox, notice: 'Sandbox has been enqueued for the deployment.' }
      format.json { head :accepted }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sandbox
      @sandbox = Sandbox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sandbox_params
      params.require(:sandbox).permit(:name)
    end

    def api?
      request.format.json?
    end
end
