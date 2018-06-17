class MicropostsController < ApplicationController
    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            respond_to do |format|
                format.js
            end
        else
            redirect_to current_user
        end

    end
    def destroy
        @micropost = current_user.microposts.find_by(id: params[:id])
        if micropost
            micropost.destroy
            respond_to do |format|
                format.js
            end
        end
    end

    private
    attr_reader :micropost
    def micropost_params
        params.require(:micropost).permit(:title,:content,:picture)
    end

end
