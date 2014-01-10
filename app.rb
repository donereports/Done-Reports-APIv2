class App < Jsonatra::Base

  def require_user_auth
    @user = User.first :username => 'aaronpk'
  end

  before do
    # puts "#{request.env['REQUEST_METHOD']} #{request.path} (#{session[:username]})"
  end

  get '/' do
    { hello: 'world' }
  end

end
