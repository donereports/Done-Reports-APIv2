class App < Jsonatra::Base

  get '/entry/query' do
    require_user_auth

    @group = Group.first :slug => params[:group]
    param_error :group, 'invalid', 'Invalid group was specified' if @group.nil?

    if @group
      is_member = (@user.groups & @group).length > 0
      if !is_member
        param_error :group, 'forbidden', 'This group is not public, and you are not a member' if @group.private
      end
    end

    halt if response.error?

    query = Entry.all group: @group

    entries = []
    query.all.each do |entry|
      entries << entry.api_hash(@group.timezone)
    end

    {
      group: @group.slug,
      entries: entries
    }
  end

end
