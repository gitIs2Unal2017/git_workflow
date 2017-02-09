class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = nil
    if params.has_key?(:comment_id)
      @images = Image.images_by_comment_or_post_id(params[:comment_id], "Comment")
    elsif params.has_key?(:post_id)
      @images = Image.images_by_comment_or_post_id(params[:post_id], "Post")
    else
      @images = Image.load_images
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end



  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    if params.has_key?(:comment_id)
      comment = Comment.comment_by_id(params[:comment_id])
      comment.images<<@image
    elsif params.has_key?(:post_id)
      post = Post.post_by_id(params[:post_id])
      post.images<<@image
    end
    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    type = ""
    if params.has_key?(:comment_id)
      type = "Comment"
      comment = Comment.comment_by_id(params[:comment_id])
    elsif params.has_key?(:post_id)
      type = "Post"
      post = Post.post_by_id(params[:post_id])
    end
    if type == "Comment"
      if comment && @image && @image.imageable_type == "Comment" && @image.imageable_id == comment.id
        @image.destroy
        respond_to do |format|
          format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to images_url, notice: 'Image was not destroyed.' }
          format.json { head :no_content }
        end
      end
    else
      if post && @image && @image.imageable_type == "Post" && @image.imageable_id == post.id
        @image.destroy
        respond_to do |format|
          format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          format.html { redirect_to images_url, notice: 'Image was not destroyed.' }
          format.json { head :no_content }
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.image_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:image, :imageable_id, :imageable_type)
    end
end
