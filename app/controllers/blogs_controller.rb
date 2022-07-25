class BlogsController < ApplicationController
  before_action :authorize_request, :current_user
  # before_action :current_user

  # def current_user
  #   self.user_id = JsonWebToken.decode()
  # end

  def current_user
    @current_user = nil
    if decoded_token
      data = decoded_token
      user = User.find_by(id: data[:user_id])
      if user
        @current_user ||= user
      end
    end
  end

  def decoded_token
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if header
      begin
        @decoded_token ||= JsonWebToken.decode(header)
      rescue Error => e
        return render json: {errors: [e.message]}, status: :unauthorized
      end
    end
  end

  def index
    @blogs = Blog.all
    render json: @blogs
  end

  def show
    @blog = Blog.find(params[:id])
    render json: @blog
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      render json: @blog, status: :created
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def update
    @blog = Blog.find(params[:id])

    if @blog.update(blog_params)
      render json: @blog, status: :created
    else
      render json: @blog.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    render json: {msg: "Blog deleted successfully!"}
  end

  private
    def blog_params
      params.require(:blog).permit(:title, :body).merge(user_id: @current_user.id)
    end

end
