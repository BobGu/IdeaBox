require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort}
  end

  def clean_tags(idea_tags)
   idea_tags['tags'] =
     (idea_tags['tags']||"").split(" ") # regex offers more power
  end

  post '/' do
    clean_tags params[:idea]
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  put '/:id' do |id|
    clean_tags params[:idea]
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/:tag/same_tags' do |tag|
    ideas = IdeaStore.find_all_by_tag(tag)
    erb :index, locals: {ideas: ideas}
  end
end
