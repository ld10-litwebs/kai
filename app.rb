require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'

enable :sessions

helpers do
  def current_user 
    User.find(session[:user])
  end
end


get '/' do
  @contents = Post.order('id desc').all
  @comments = Comment.order('id desc').all
  erb :index
end

get '/signin' do
    erb :sign_in
end

get '/signup' do
    erb :sign_up
end

post '/signin' do
  user = User.find_by(mail: params[:mail])
  if user && user.authenticate(params[:password])
    session[:user] = user.id
  end
  redirect '/'
end

post '/signup' do
  @user = User.create(mail:params[:mail],password:params[:password],
  password_confirmation:params[:password_confirmation],point:10)
  if @user.persisted?
    session[:user] = @user.id
  end
  redirect '/'
end

get '/signout' do
  session[:user] = nil
  redirect '/'
end


post '/new' do
     str = params[:body]
     puts str
      str =str.gsub(/\r\n|\r|\n/, "<br />")
    puts str
  if current_user.point >= 2 
    current_user.posts.create({
        text: str,
        number_of_comment: 0
    })
    current_user.update_column(:point, current_user.point - 2)
    redirect '/'
  else
    puts 'not enough point'
  end
  redirect '/'
end


post '/new_comment/:id' do
      str = params[:cm]
     puts str
      str =str.gsub(/\r\n|\r|\n/, "<br />")
    puts str
    current_user.comments.create({
        text: str,
        post_id: params[:id],
        like: 0,
        encouraged: false
        
    })
    number =Post.find(params[:id])
    number.update_column(:number_of_comment, number.number_of_comment + 1)
    redirect "/comment/#{params[:id]}"
end

get '/comment/:id' do
  @comments = Comment.where(post_id: params[:id]).all
  @posts = Post.find(params[:id])
  @comment_post_id =params[:id]
  
  erb :comment
end

get '/user/:id'  do
  @posts = Post.where(user_id: params[:id]).all
  erb :user
end


post '/enc/:id' do
  comment=Comment.find(params[:id])
  if comment.encouraged == false
  comment.update_column(:encouraged,true)
  comment_user=User.find(comment.user_id)
  comment_user.update_column(:point,comment_user.point + 5 )
else
end
redirect "/comment/#{comment.post_id}"
end