module SessionsHelper
    
    #logs the user in
    def log_in(admin_user) 
        session[:admin_user_id] = admin_user.id #creates a session (cookie) for user_id  https://www.reddit.com/r/ruby/comments/48ok7h/i_think_ive_got_sessionuser_id_userid_working/ acc 25/08/16 14:37 Valdivia
        
    end
    
    def remember(admin_user)
        admin_user.remember #calls the remember method from the User model, which generates a remember token (a secure hash) that's saved to the database in the user's remember_token column
        cookies.permanent.signed[:admin_user_id] = admin_user.id #creates a secure (that is, encrypted) permanent duration cookie in the user's browser, with the user id
        cookies.permanent[:remember_token] = admin_user.remember_token #creates a permanent duration cookie with the remember token of the user
    end
    
    def current_user #defines the current user
        if (admin_user_id = session[:admin_user_id]) #sets user_id to cookie data
            @current_user ||= User.find_by(id: session[:admin_user_id]) #@current_user is either @current_user OR whatever user is found by the user model in the DB when looking for id = session[:admin_user_id]
      
            elsif (admin_user_id = cookies.signed[:admin_user_id]) #otherwise, if user_id = 
            admin_user = User.find_by(id: admin_user_id)
            if admin_user && admin_user.authenticated?(:remember, cookies[:remember_token])
                log_in admin_user
                @current_user = admin_user
            end
        end
    end

    def current_user?
        admin_user == current_user
    end
    
    def logged_in?
        !current_user.nil?
    end
    
    def forget(admin_user)
       admin_user.forget
       cookies.delete(:admin_user_id)
       cookies.delete(:remember_token)

    end

    #logs out
    def log_out
        forget(current_user)
        session.delete(:admin_user_id)
        @current_user = nil
    end
    
    # Redirects to stored location (or to the default).
    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    
    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

    
end
