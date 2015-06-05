class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comments_params)
    @comment.save
    render json: params
  end

  def comments_params
    params.require(:comment).permit(:content)
  end

end
