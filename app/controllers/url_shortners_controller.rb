class UrlShortnersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:stats,:fetch_short_url,:show]
  skip_before_action :verify_authenticity_token, only: [:stats,:fetch_short_url]
  before_action :authenticate_request, only: [:stats,:fetch_short_url]

  def index
    @url_shortners = UrlShortner.all.paginate(page: params[:page])
  end

  def create
    @url_shortner = UrlShortner.fetch_or_create_short_url(params[:url_shortner][:original_url]) if params[:url_shortner][:original_url].present?
    @url_shortners = UrlShortner.all.paginate(page: params[:page])
    render :index
  end

  def show
    @url_shortner = UrlShortner.find_by_short_url(params[:short_url])
    if current_user
      user = current_user
    else 
      user = User.find_by(email:'ethirajsrinivasan@gmail.com')
    end  
    UrlShortnerLog.create!(user_id: user.id,
                         url_shortner_id: @url_shortner.id,
                         browser: browser.name,
                         version: browser.version,
                         platform: browser.platform.id)
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

  def fetch_short_url
    url_shortner = UrlShortner.fetch_or_create_short_url(params[:url])
    render json: { "original_url": url_shortner.original_url,
                   "sanitized_url": url_shortner.sanitized_url,
                   "short_url": root_url + url_shortner.short_url }
  end

  private
  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

end