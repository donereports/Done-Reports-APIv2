class GroupUser
  include DataMapper::Resource
  belongs_to :user, :key => true
  belongs_to :group, :key => true
  property :is_admin, Boolean, :default => false
  property :updated_at, DateTime
  property :created_at, DateTime
end