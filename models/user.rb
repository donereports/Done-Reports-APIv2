class User
  include DataMapper::Resource
  property :id, Serial

  has n, :groups, :through => :group_user
  has n, :orgs, :through => :org_user

  property :username, String, :length => 255
  property :email, String, :length => 255
  property :nicks, String, :length => 512
  property :active, Boolean, :default => true

  property :updated_at, DateTime
  property :created_at, DateTime

  def email_for_org(org)
    return email if org.nil?
    ou = org_user.first(:org_id => org.id)
    return email if ou.nil?
    return email if ou.email.nil?
    ou.email
  end

  def avatar_url
    if !email.nil? && email != ''
      "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(email)}?s=40&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
    else
      "https://a248.e.akamai.net/assets.github.com/images/gravatars/gravatar-user-420.png"
    end
  end

  def api_hash
    {
      :username => username,
      :avatar => avatar_url
    }
  end
end