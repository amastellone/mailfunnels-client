class MailFunnelsUser

# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Updates the users info from infusionsoft
# Used to make sure that user is up to date
# with infusionsoft and to update the users tags
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN (true/false) whether users info was updated
#
  def self.can_user_access_app(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: can_user_access_app(client_id)"


    # Get user from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user in our database
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning False (FAILURE)----"
      puts "======================="
      return false
    end


    # get latest user information from infusionsoft
    contact = Infusionsoft.data_load('Contact', user.clientid, [:FirstName, :LastName, :Email, :Website, :StreetAddress1, :City, :State, :PostalCode, :Groups])


    #check if information retrieval from infustionsoft was successful
    if contact.nil?
      puts "ERROR - contact information not retrieved from infusionsoft using clientid = #{client_id}"
      puts "---- Returning False (FAILURE)----"
      puts "======================="
      return false
    end


    # Update User Info In Our DB
    user.put('', {
        :first_name => contact['FirstName'],
        :last_name => contact['LastName'],
        :street_address => contact['StreetAddress1'],
        :city => contact['City'],
        :state => contact['State'],
        :zip => contact['PostalCode'],
        :client_tags => contact['Groups'],
    })

    # Successful - return true
    puts "---- Returning True (SUCCESS)----"
    puts "======================="
    return true

  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Updates the users info from infusionsoft
# Used to make sure that user is up to date
# with infusionsoft and to update the users tags
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN (true/false) whether users info was updated
#
  def self.update_user_info(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: update_user_info(client_id)"


    # Get user from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user in our database
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning False (FAILURE)----"
      puts "======================="
      return false
    end


    # get latest user information from infusionsoft
    contact = Infusionsoft.data_load('Contact', user.clientid, [:FirstName, :LastName, :Email, :Website, :StreetAddress1, :City, :State, :PostalCode, :Groups])


    #check if information retrieval from infustionsoft was successful
    if contact.nil?
      puts "ERROR - contact information not retrieved from infusionsoft using clientid = #{client_id}"
      puts "---- Returning False (FAILURE)----"
      puts "======================="
      return false
    end


    # Update User Info In Our DB
    user.put('', {
        :first_name => contact['FirstName'],
        :last_name => contact['LastName'],
        :street_address => contact['StreetAddress1'],
        :city => contact['City'],
        :state => contact['State'],
        :zip => contact['PostalCode'],
        :client_tags => contact['Groups'],
    })

    # Successful - return true
    puts "---- Returning True (SUCCESS)----"
    puts "======================="
    return true

  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Returns the User's subscription plan id or 1 if one is not found or -1 on error
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: INTEGER
# ----------------
# -1 : Error
# -2 : MailFunnels Free Trial User
# -99 : Mailfunnels Free Trial Ended and No Plan (Account Disabled)
# 106 : MailFunnels 1k
# 108 : MailFunnels 2k
# 110 : MailFunnels 4k
# 112 : MailFunnels 8k
# 114 : MailFunnels 12k
# 116 : MailFunnels 20k
# 118 : MailFunnels 35k
# 120 : MailFunnels Failed Payment
# 153 : Mailfunnels 60 day trial member
#
  def self.get_user_plan(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: get_user_plan(client_id)"


    # Update the User info
    status = self.update_user_info(client_id)


    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end


    # Parse through Tags and set current plan
    current_plan = 1
    multiple_sub_tags = false
    tags = user.client_tags.split(",")


    tags.each do |tag|

      # Convert tag to integer
      temp = tag.to_i

      # If tag is a subscription tag, update current_plan
      if temp >= 106 and temp <= 118
        # If temp is greater than current_plan
        if temp > current_plan
          if current_plan >= 106 and temp <= 118
            multiple_sub_tags = true
          end
          current_plan = temp
        end
      end

    end

    if multiple_sub_tags
      puts "WARN - USER WITH CLIENT_ID = #{client_id} HAS MULTIPLE SUBSCRIPTION TAGS"
    end

    if current_plan == 1
      puts "WARN - USER WITH CLIENT_ID = #{client_id} HAS NO SUBSCRIPTION TAGS"
    end

    puts "---- Returning User Plan (SUCCESS) ----"
    puts "======================="
    return current_plan
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user has failed payment tag
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN
  def self.has_failed_payment(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: has_failed_payment(client_id)"

    # Update the User info
    status = self.update_user_info(client_id)

    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end

    # Parse through Tags and set current plan
    tags = user.client_tags.split(",")
    tags.each do |tag|
      # Convert tag to integer
      temp = tag.to_i
      # check if temp == failed to pay installment tag id (120)
      if temp == 120
        puts "INFO - user with id = #{user.id} has failed to pay installment tag"
        puts "---- Returning True (SUCCESS) ----"
        puts "======================="
        return true
      end

    end

    puts "INFO - user with id = #{user.id} does not have failed to pay installment tag"
    puts "---- Returning False (SUCCESS) ----"
    puts "======================="
    return false
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user is a trial user (any trial)
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: 1 for regular, 2 for student, 0 for none, or -1 if error
  def self.is_trial_user(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: is_trial_user(client_id)"
    #check for both trials
    regular = is_regular_trial_user(client_id)
    student = is_student_trial_user(client_id)
    error_regular = false
    error_student = false

    # if no error and true, return true
    if regular != -1
      if regular
        puts "INFO - user IS a (regular) trial user"
        puts "---- Returning True (SUCCESS) ----"
        puts "======================="
        return 1
      end
    else
      error_regular = true
    end

    # if no error and true, return true
    if student != -1
      if student
        puts "INFO - user IS a (student) trial user"
        puts "---- Returning True (SUCCESS) ----"
        puts "======================="
        return 2
      end
    else
      error_student = true
    end

    #Error checking and logging
    if error_regular
      puts "ERROR - while calling is_regular_trial_user(client_id), there was an error"
    end
    if error_student
      puts "ERROR - while calling is_student_trial_user(client_id), there was an error"
    end
    if error_regular && error_student
      puts "ERROR - error calling BOTH student and regular functions"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end

    #else return false (will technically return false if only one of the function calls failed, but what are the chances of that.....)
    puts "INFO - user is NOT a trial user"
    puts "---- Returning False (SUCCESS) ----"
    puts "======================="
    return 0

  end

# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user is a REGULAR trial user
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN or -1 if error
  def self.is_regular_trial_user(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: is_regular_trial_user(client_id)"


    # Update the User info
    status = self.update_user_info(client_id)


    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end

    # Parse through Tags and set current plan
    tags = user.client_tags.split(",")
    tags.each do |tag|
      # Convert tag to integer
      temp = tag.to_i
      # check if temp == student trial tag id (153)
      if temp == 139
        puts "INFO - user with id = #{user.id} has regular trial tag"
        puts "---- Returning True (SUCCESS) ----"
        puts "======================="
        return true
      end

    end

    puts "INFO - user with id = #{user.id} does not have regular trial tag"
    puts "---- Returning False (SUCCESS) ----"
    puts "======================="
    return false
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user is a REGULAR trial user
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN or -1 if error
  def self.is_regular_trial_valid(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: is_regular_trial_valid(client_id)"


    # Update the User info
    status = self.update_user_info(client_id)


    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end

    # Parse through Tags and set current plan
    tags = user.client_tags.split(",")
    tags.each do |tag|
      # Convert tag to integer
      temp = tag.to_i
      # check if temp == regular trial tag id (145)
      if temp == 145
        puts "INFO - user with id = #{user.id} HAS regular trial ended tag"
        puts "---- Returning False (SUCCESS) ----"
        puts "======================="
        return false
      end

    end

    puts "INFO - user with id = #{user.id} does NOT have regular trial ended tag"
    puts "---- Returning True (SUCCESS) ----"
    puts "======================="
    return true
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user is a STUDENT trial user
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN, -1 if error
  def self.is_student_trial_user(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: is_student_trial_user(client_id)"


    # Update the User info
    status = self.update_user_info(client_id)


    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end

    # Parse through Tags and set current plan
    tags = user.client_tags.split(",")
    tags.each do |tag|
      # Convert tag to integer
      temp = tag.to_i
      # check if temp == student trial tag id (153)
      if temp == 153
        puts "INFO - user with id = #{user.id} has student trial tag"
        puts "---- Returning True (SUCCESS) ----"
        puts "======================="
        return true
      end

    end

    puts "INFO - user with id = #{user.id} does not have student trial tag"
    puts "---- Returning False (SUCCESS) ----"
    puts "======================="
    return false
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Checks if user is a REGULAR trial user
#
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: BOOLEAN or -1 if error
  def self.is_student_trial_valid(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: is_regular_trial_valid(client_id)"


    # Update the User info
    status = self.update_user_info(client_id)


    # If Update user failed, return -1
    if status === false
      puts "ERROR - unable to update our database with the latest infusionsoft data for user with client_id = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end


    # Get the Updated User from DB
    user = User.where(clientid: client_id).first


    #check if we successfully found the user
    if user.nil?
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    else
      puts "INFO - user with id = #{user.id} found with clientid = #{client_id}"
    end

    # Parse through Tags and set current plan
    tags = user.client_tags.split(",")
    tags.each do |tag|
      # Convert tag to integer
      temp = tag.to_i
      # check if temp == student trial tag id (153)
      #TODO
      #INSERT THE CORRECT VALUE IN PLACE OF 145
      if temp == 145
        puts "INFO - user with id = #{user.id} HAS student trial ended tag"
        puts "---- Returning False (SUCCESS) ----"
        puts "======================="
        return false
      end

    end

    puts "INFO - user with id = #{user.id} does NOT have student trial ended tag"
    puts "---- Returning True (SUCCESS) ----"
    puts "======================="
    return true
  end


# MAILFUNNELS USER UTIL FUNCTION
# ------------------------------
# Returns the number of subscribers left in subscription
#
# PARAMETERS
# ----------
# client_id: ID of the Infusionsoft Contact
#
# Returns: INTEGER number of subscribers left, -1 if error, -2 if no plan
#
  def self.get_remaining_subs(client_id)
    puts "======================="
    puts "lib/mail_funnels_user :: get_remaining_subs(client_id)"


    check = is_student_trial_user(client_id)

    if check != -1
      if check
        check = is_student_trial_valid(client_id)
        if check != -1
          if check
            # Get User from DB
            user = User.where(clientid: client_id).first

            # If user not found, return -1
            unless user
              puts "ERROR - user not found with clientid = #{client_id}"
              puts "---- Returning -1 (FAILURE) ----"
              puts "======================="
              return -1
            end

            # Get App for User
            app = App.where(user_id: user.id).first

            # If no app found, return -1
            unless app
              puts "ERROR - app not found with user_id = #{user.id}"
              puts "---- Returning -1 (FAILURE) ----"
              puts "======================="
              return -1
            end

            # Get Number of Subscribers in app
            num_subscribers = app.subscribers.size
            num_subscribers = 4000 - num_subscribers
            puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, has #{num_subscribers} remaining"
            puts "---- Returning Number of Remaining Subscribers (SUCCESS)----"
            puts "======================="
            return num_subscribers
          end
        end
      end
    end


    check = is_regular_trial_user(client_id)

    if check != -1
      if check
        check = is_regular_trial_valid(client_id)
        if check != -1
          if check
            # Get User from DB
            user = User.where(clientid: client_id).first

            # If user not found, return -1
            unless user
              puts "ERROR - user not found with clientid = #{client_id}"
              puts "---- Returning -1 (FAILURE) ----"
              puts "======================="
              return -1
            end

            # Get App for User
            app = App.where(user_id: user.id).first

            # If no app found, return -1
            unless app
              puts "ERROR - app not found with user_id = #{user.id}"
              puts "---- Returning -1 (FAILURE) ----"
              puts "======================="
              return -1
            end

            # Get Number of Subscribers in app
            num_subscribers = app.subscribers.size
            num_subscribers = 500 - num_subscribers
            puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, has #{num_subscribers} remaining"
            puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
            puts "======================="
            return num_subscribers


          end
        end
      end
    end

    puts "INFO - user with clientid = #{client_id} is NOT a trial account"

    # Get the current plan for user
    plan = self.get_user_plan(client_id)

    # If failed, return -1
    if plan === -1
      puts "ERROR - user with clientid = #{client_id} did NOT retrieve a valid subscription"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end

    # Get User from DB
    user = User.where(clientid: client_id).first

    # If user not found, return -1
    unless user
      puts "ERROR - user not found with clientid = #{client_id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end

    # Get App for User
    app = App.where(user_id: user.id).first

    # If no app found, return -1
    unless app
      puts "ERROR - app not found with user_id = #{user.id}"
      puts "---- Returning -1 (FAILURE) ----"
      puts "======================="
      return -1
    end

    # Get Number of Subscribers in app
    num_subscribers = app.subscribers.size

    case plan
      when 106
        num_subscribers = 1000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 108
        num_subscribers = 2000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 110
        num_subscribers = 4000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 112
        num_subscribers = 8000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 114
        num_subscribers = 12000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 116
        num_subscribers = 20000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      when 118
        num_subscribers = 35000 - num_subscribers
        puts "INFO - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} has #{num_subscribers} remaining"
        puts "---- Returning Number of Remaining Subscribers (SUCCESS) ----"
        puts "======================="
        return num_subscribers
      else
        puts "ERROR - user with clientid = #{client_id}, app_id = #{app.id}, and subscription tag = #{plan} created an error when retrieving remaining subs"
        puts "---- Returning -1 (FAILURE) ----"
        puts "======================="
        return -1
    end


  end


end