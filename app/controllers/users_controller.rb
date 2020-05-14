class UsersController < ApplicationController

    before do
        require_login
    end
    
    get '/:slug' do
        @user = User.find_by_slug(params[:slug])
        @recipes = []
        Recipe.all.each do |r|
            if r.user_id == @user.id
                @recipes << r 
            end
        end
        erb :"users/show"
    end

    get '/:slug/cookbook' do
        @user = User.find_by_slug(params[:slug])
        @recipes = @user.recipes
        erb :"users/cookbook"
    end

    post '/cookbook/:id' do
        if params[:do_this] == "Add to my Cookbook"
            @recipe = Recipe.find(params[:id])
            current_user.recipes << @recipe
        end
        redirect "/#{current_user.slug}/cookbook"
    end

    delete '/cookbook/:id' do
        if params[:do_this] == "Remove from my Cookbook"
            @saved_recipe = SavedRecipe.find_by(recipe_id: params[:id], user_id: current_user.id)
            @saved_recipe.delete
        end
        redirect "/#{current_user.slug}/cookbook"
    end

end