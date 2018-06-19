class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feed.desc.paginate page: params[:page]
    else
      @feed_items = Micropost.desc.paginate page: params[:page]
    end
    @pop_users = User.joins("INNER JOIN microposts ON microposts.user_id = users.id").order("? ASC", User.count).distinct
  end
end
