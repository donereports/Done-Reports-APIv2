class Entry
  include DataMapper::Resource
  property :id, Serial

  belongs_to :group
  belongs_to :user

  has n, :tags

  property :date, DateTime
  property :type, String, :length => 100
  property :text, Text

  property :created_at, DateTime
  property :updated_at, DateTime

  def api_hash(timezone)
    timezone = 
    {
      :id => id,
      :content => text,
      :date => date.to_time.localtime(timezone.utc_offset).iso8601,
      :tags => []
    }
  end
end
