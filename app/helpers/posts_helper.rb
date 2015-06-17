module PostsHelper
  def vote_post_link(post)
    if post.users_who_vote.include? current_user 
      return link_to "-1!", upvote_post_path(post)
    else 
      return link_to "+1!", upvote_post_path(post) 
    end
    
  end

end
