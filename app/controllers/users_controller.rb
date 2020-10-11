class UsersController < ApplicationController

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        if params[:username] == "" || params[:password] == "" || params[:email] == ""
            redirect to "/signup"
        else
            @user = User.new(:username => params[:username], :password => params[:password], :email => params[:email])
            @user.save
            session[:user_id] = @user.id
            redirect to "/tweets"
        end
    end

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        if params[:username] == "" || params[:password] == ""
            redirect to "/login"
        else
            user = User.find_by(:username => params[:username])
            if user && user.authenticate(params[:password])
                session[:user_id] = user.id
                redirect to "/tweets"
            else
                redirect to "/login"
            end
        end
    end

    get '/logout' do
        if logged_in?
            session.destroy
            redirect to "/login"
        else
            redirect to "/"
        end
    end
end
