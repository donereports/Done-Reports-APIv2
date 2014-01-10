class App < Jsonatra::Base

  def require_user_auth
    @user = User.first :username => 'aaronpk'
  end

  def require_group_auth
    @group = Group.first :token => params[:group_token]
    if @group.nil?
      param_error :group_token, 'missing', 'Missing group_token' if params[:group_token].blank?
      halt if response.error?      
    end
  end

  before do
    # puts "#{request.env['REQUEST_METHOD']} #{request.path} (#{session[:username]})"
  end

  get '/' do
    { hello: 'world' }
  end

end
