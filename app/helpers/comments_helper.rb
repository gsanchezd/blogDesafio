module CommentsHelper
  def vote_comment_link(comment)
    if comment.users_who_voted.include? current_user 
      return link_to "-1!", upvote_post_comment_path(comment.post, comment)
    else 
      return link_to "+1!", upvote_post_comment_path(comment.post, comment)
    end
  end
end
