class UrlShortnersController < ApplicationController

  def index
    @url_shortners = UrlShortner.all.paginate(:page => params[:page])
  end
  
  def create
    @url_shortner = UrlShortner.fetch_or_create_short_url(params[:url_shortner][:original_url])
    @url_shortners = UrlShortner.all.paginate(:page => params[:page])
    render :index
  end

  def show
    @url_shortner = UrlShortner.find_by_short_url(params[:short_url])
    UrlShortnerLog.create!(user_id: current_user.id, url_shortner_id: @url_shortner.id,browser: browser.name,version: browser.version, platform: browser.platform.id)
    redirect_to @url_shortner.sanitized_url
  end

  def stats
    @url_shortner = UrlShortner.find_by(short_url: params[:id])
    if @url_shortner.nil?
      render json: {'error': 'Short Url Not Found'}
    else
      render json: JSON.pretty_generate({'data': @url_shortner.stats})
    end
  end

end