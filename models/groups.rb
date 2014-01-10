class Group
  include DataMapper::Resource
  property :id, Serial

  belongs_to :org
  belongs_to :irc_server
  has n, :entries
  has n, :users, :through => :group_user

  property :token, String, :length => 128
  property :name, String, :length => 128

  property :irc_channel, String, :length => 100
  property :timezone, String, :length => 100

  property :prompt_command, String, :length => 50
  property :prompt_from, DateTime, :default => '2000-01-01 09:00:00'
  property :prompt_to, DateTime, :default => '2000-01-01 18:00:00'

  property :updated_at, DateTime
  property :created_at, DateTime

  def slug
    irc_channel.gsub(/^#/, '').downcase
  end

  def api_hash(is_admin=false)
    zone = Timezone::Zone.new :zone => due_timezone
    time = due_time.to_time.strftime("%H:%M")

    {
      :slug => slug,
      :name => name,
      :org_name => org.name,
      :channel => irc_channel,
      :server => (ircserver ? ircserver.api_hash : nil),
      :timezone => timezone,
      :date_created => created_at,
      :members => users.length,
      :is_admin => is_admin
    }
  end

end