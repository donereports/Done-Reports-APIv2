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
    if last_entry and last_entry.type == params[:type] and last_entry.text == params[:text]
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

      # Add tags for this entry
      Tag.parse_str(params[:text]).each do |tag|
        Tag.create({entry: entry, tag: tag})
      end

      { 
        result: 'ok',
        entry: entry.id,
        group: @group.slug
      }
    end
  end

  post '/entry/delete' do
    require_group_auth

    param_error :username, 'missing', 'username parameter required' if params[:username].blank?

    # Load the user (usernames are globally unique)
    @user = User.first :username => params[:username]
    param_error :username, 'invalid', 'Invalid username was specified' if @user.nil?

    if @user
      # Verify the user is part of the authenticated group
      is_member = (@user.groups & @group).length > 0
      param_error :username, 'invalid', 'This user is not part of the specified group' unless is_member
    end

    halt if response.error?

    # If text is specified, then remove the most recent entry matching the text
    if params[:text]
      last_entry = Entry.last({ group: @group, user: @user, text: params[:text] })
    else
      # Otherwise, remove the most recent entry for the user
      last_entry = Entry.last({ group: @group, user: @user })
    end

    deleted = false

    if last_entry
      # Can only delete entries from the last hour
      if last_entry.date >= (DateTime.now - 1.0/24.0)
        last_entry.tags.destroy
        last_entry.destroy
        deleted = true
      end
    end

    { 
      result: (deleted ? 'deleted' : 'not_found'),
      group: @group.slug
    }
  end

end
