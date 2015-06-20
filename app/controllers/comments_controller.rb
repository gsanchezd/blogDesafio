class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comments_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html  { redirect_to @comment.post, notice: "Tu comentario ha sido creado" }
        format.js
      else
        format.html { redirect_to @comment.post, alert: "Tu comentario no ha podido ser creado" }
        format.js
      end      
    end
      
  end

  def upvote
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    @vote = @comment.votes.build(user:current_user)
    if @comment.users_who_voted.include? current_user
      @comment.votes.where(user:current_user).first.delete
      redirect_to @post, notice: "Tu voto ha sido borrado"
    elsif @vote.save
      redirect_to @post, notice: "Tu voto ha sido asignado"
    else
      redirect_to @post, notice: "Tu voto no ha poido ser asignado"
    end
  end


  def comments_params
    params.require(:comment).permit(:content)
  end

end
