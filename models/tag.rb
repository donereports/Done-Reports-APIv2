class Tag
  include DataMapper::Resource
  property :id, Serial

  property :tag, String, :length => 100, :index => true
  belongs_to :entry

  property :created_at, DateTime

  def self.parse_str(string)
    string.scan(/#([\w-]{2,})/).map{|a| a[0]}.uniq
  end
end
