class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = nil
    @user = User.order("RANDOM()").limit(1)[0]
    @post = @user.posts[rand(@user.posts.length)]
    if params.has_key?(:user_id)
      @comments = Comment.comments_by_user(params[:user_id])
    else
      @comments = Comment.load_comments
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    user = User.user_by_id(params[:user_id])
    post = Post.post_by_id(params[:post_id])
    if user && post
      user.comments<<@comment
      post.comments<<@comment
      respond_to do |format|
        if @comment.save
          format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_url,notice: "The user or post is not valid"
    end

  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    user = User.user_by_id(params[:user_id])
    if @comment && user && @comment.user_id == user.id
      @comment.destroy
      respond_to do |format|
        format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to comments_url, notice: 'Comment was not destroyed, because the user do not correspond to the user who created the comment' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.comment_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:description, :user_id, :post_id)
    end
end
