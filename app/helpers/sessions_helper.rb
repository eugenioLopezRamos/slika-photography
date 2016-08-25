module SessionsHelper
    
    #logs the user in
    def log_in(user) 
        session[:admin_user_id] = user.id #creates a session (cookie) for user_id  https://www.reddit.com/r/ruby/comments/48ok7h/i_think_ive_got_sessionuser_id_userid_working/ acc 25/08/16 14:37 Valdivia
    end
    
    def remember(user)
        user.remember #calls the remember method from the User model, which generates a remember token (a secure hash) that's saved to the database in the user's remember_token column
        cookies.permanent.signed[:admin_user_id] = user.id #creates a secure (that is, encrypted) permanent duration cookie in the user's browser, with the user id
        cookies.permanent[:remember_token] = user.remember_token #creates a permanent duration cookie with the remember token of the user
    end
    
    def current_user #defines the current user
        if (user_id = session[:admin_user_id]) #if user_id is equal to the session data...
            @current_user ||= User.find_by(id: session[:admin_user_id]) #@current_user is either @current_user OR whatever user is found by the user model in the DB when looking for id = session[:admin_user_id]
      
            elsif (user_id = cookies.signed[:admin_user_id]) #otherwise, if user_id = 
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in user
                @current_user = user
            end
        end
    end
    
    def logged_in?
        !current_user.nil?
    end
    
    def forget(user)
       user.forget
       cookies.delete(:admin_user_id)
       cookies.delete(:remember_token)
    end
    
    
    
    #logs out
    def log_out
        forget(current_user)
        session.delete(:admin_user_id)
        @current_user = nil
    end
    
    
end
