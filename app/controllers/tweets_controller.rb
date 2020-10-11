class TweetsController < ApplicationController

    get '/tweets' do
        if logged_in?
            @tweets = Tweet.all
            erb :'tweets/index'
        else
            redirect to "/login"
        end
    end

    get '/tweets/new' do
        erb :'tweets/new'
    end

    post '/tweets' do
        if logged_in?
            if params[:content] == ""
                redirect to "/tweets/new"
            else
                @tweet = current_user.tweets.build(content: params[:content])
                if @tweet.save
                    redirect to "/tweets/#{@tweet.id}"
                else
                    redirect to "/tweets/new"
                end
            end
        else
            redirect to "/login"
        end
    end

    get '/tweets/:id' do
        if !logged_in?
            redirect to "/"
        else
            @tweet = Tweet.find(params[:id])
            erb :'tweets/show'
        end
    end

    get '/tweets/:id/edit' do
        @tweet = Tweet.find(params[:id])
        erb :'tweets/edit'
    end

    patch '/tweets/:id' do
        if logged_in?
            if params[:content] == ""
                redirect to "/tweets/#{params[:id]}/edit"
            else
                @tweet = Tweet.find(params[:id])
                if @tweet && @tweet.user == current_user
                    if @tweet.update(:content => params[:content])
                        redirect to "/tweets/#{@tweet.id}"
                    else
                        redirect to "/tweets/#{params[:id]}/edit"
                    end
                else
                    redirect to "/tweets"
                end
            end
        else
            redirect to "/"
        end
    end

    delete '/tweets/:id/delete' do
        if logged_in?
            @tweet = Tweet.find_by_id(params[:id])
            if @tweet && @tweet.user == current_user
              @tweet.delete
            end
            redirect to '/tweets'
        else
            redirect to '/login'
        end
    end

end
