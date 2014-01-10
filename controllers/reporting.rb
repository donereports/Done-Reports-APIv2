class App < Jsonatra::Base

  post '/entry/create' do
    require_group_auth

    param_error :username, 'missing', 'username parameter required' if params[:username].blank?
    param_error :type, 'missing', 'type parameter required' if params[:type].blank?
    param_error :text, 'missing', 'text parameter required' if params[:text].blank?

    # Load the user (usernames are globally unique)
    @user = User.first :username => params[:username]
    param_error :username, 'invalid', 'Invalid username was specified' if @user.nil?

    if @user
      # Verify the user is part of the authenticated group
      is_member = (@user.groups & @group).length > 0
      param_error :username, 'invalid', 'This user is not part of the specified group' unless is_member
    end

    halt if response.error?

    # Check for duplicates - don't add a new entry if they just reported an exact match
    last_entry = Entry.last({ group: @group, user: @user })
    if last_entry.type == params[:type] and last_entry.text == params[:text]
      { 
        result: 'duplicate',
        entry: last_entry.id,
        group: @group.slug
      }
    else 
      entry = Entry.create({
        group: @group,
        user: @user,
        date: DateTime.now,
        type: params[:type],
        text: params[:text]
      })

      { 
        result: 'ok',
        entry: entry.id,
        group: @group.slug
      }
    end
  end


end
