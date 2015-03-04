#encoding: UTF-8
class FeedbackTargetsController < ProtectedController
  before_filter :define_breadcrumbs, :only => [:show, :edit]
  helper_method :render_code, :render_js_include

  def index
    @feedback_targets = FeedbackTarget.all_targets_for_user(current_user)
  end

  def new
    @feedback_target = current_user.feedback_targets.new
  end

  def show
    @feedback_target = feedback_target
  end

  def edit
    authorize!(:write_feedback_target, feedback_target) do
      @feedback_target = feedback_target
      add_breadcrumb  t('Edit')
    end
  end

  def create
    @feedback_target =  current_user.feedback_targets.build(feedback_target_params)
    if @feedback_target.save
      flash[:notice] = translate('User application created!')
      redirect_to :action => :index
    else
      render :new
    end
  end

  def update
    authorize!(:write_feedback_target, feedback_target) do
      if feedback_target.update_attributes(feedback_target_params)
          flash[:notice] = translate('User application changed successfully!')
          redirect_to :action => :index
      else
        render :edit
      end
    end
  end

  def search_for_members
    @users = feedback_target.list_members_candidates(params[:username])
    render json: @users, :root => false, :each_serializer => UserAutocompleteSerializer
  end

  def remove_member
    authorize!(:admin_team_members, feedback_target) do
      respond_to do |format|
       if feedback_target.remove_member params[:member_id]
         format.html { redirect_to feedback_target, notice: 'Members successfully removed.' }
         format.json { render json: feedback_target.members, :root => false, :each_serializer => UserAutocompleteSerializer }
         # added:
         format.js   { render action: 'members_list' }
       else
         format.html { render action: 'edit' }
         format.json { render json: feedback_target.errors, status: :unprocessable_entity }
         # added:
         format.js   { render json: feedback_target.errors, status: :unprocessable_entity }
       end
      end
    end
  end

  def add_members
    authorize!(:admin_team_members, feedback_target) do
      respond_to do |format|
       if feedback_target.include_members params[:team_members_ids]
         format.html { render action: 'edit', notice: 'Members successfully added.' }
         format.json { render json: feedback_target.members, :root => false, :each_serializer => UserAutocompleteSerializer }
         # added:
         format.js   { render action: 'members_list' }
       else
         format.html { render action: 'edit' }
         format.json { render json: feedback_target.errors, status: :unprocessable_entity }
         # added:
         format.js   { render json: feedback_target.errors, status: :unprocessable_entity }
       end
      end
    end
  end

  def destroy
    authorize!(:remove_feedback_target, feedback_target) do
      feedback_target.destroy
      flash[:notice] = translate('User application removed successfully!')
      redirect_to :action => :index
    end
  end

protected
  def render_code feedback_target
    render_to_string(:partial => 'feedback_js_code', :layout => false, :locals => {:feedback_target => feedback_target})
  end

  def render_js_include
    render_to_string(:partial => 'feedback_js_include', :layout => false)
  end
private
  def feedback_target
    @feedback_target ||= FeedbackTarget.all_targets_for_user(current_user).find(id_param)
  end

  def define_breadcrumbs
    add_breadcrumb  feedback_target
  end

  def id_param
    params[:id]
  end

  def feedback_target_params
    params.require(:feedback_target).permit :name
    # if current_user.nil? # Guest
    #   # Remove all keys from params[:user] except :name, :email, :password, and :password_confirmation
    #   params.require(:feedback_target).permit :name
    # elsif current_user.has_role :admin
    #   params.require(:feedback_target).permit! # Allow all user parameters
    # elsif current_user.has_role :user
    #   params.require(:feedback_target).permit :name
    # end
  end
end
