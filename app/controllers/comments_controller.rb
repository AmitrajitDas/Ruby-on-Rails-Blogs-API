class CommentsController < ApplicationController
    before_action :authorize_request, :current_user

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
        @blog = Blog.find(params[:blog_id])
        @comments = @blog.comments.all
        render json: @comments
      end

      def show
        @blog = Blog.find(params[:blog_id])
        @comments = @blog.comments.find(params[:id])
        render json: @comments
      end
    
      def create
        @blog = Blog.find(params[:blog_id])
        @comment = @blog.comments.new(comment_params)
    
        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    
      def update
        @blog = Blog.find(params[:blog_id])
        @comment = @blog.comments.find(params[:id])
    
        if @comment.update(comment_params)
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end
    
      def destroy
        @blog = Blog.find(params[:blog_id])
        @comment = @blog.comments.find(params[:id])
        @comment.destroy
    
        render json: {msg: "Comment deleted successfully!"}
      end
    
      private
        def comment_params
          params.require(:comment).permit(:body).merge(user_id: @current_user.id)
        end
end
