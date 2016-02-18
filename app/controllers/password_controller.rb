class PasswordController < ApplicationController

  def check
    #if no cookie is assigned, then we do not have a valid user Id
    if !cookies.has_key?(:user_id)
      cookies[:user_id_valid] = false
      #if user has entered a user id, then an instance variable is created
      if params.has_key?(:user_id)
        @userId = params[:user_id]
        flash[:user_id] = nil
        #check if userId includes any of $#!
        if @userId.include?("$") || @userId.include?("#") || @userId.include?("!")
          flash.now[:user_id] = "Your userId must not include any of the following: $, #, !"
        else
          #save the user id in a cookie set the value of user id valid to true
          cookies[:user_id] = @userId
          cookies[:user_id_valid] = true
        end
      end
    end
    #check if there is a password
    if params.has_key?(:password)
      #assign the password to an instance variable
      @password = params[:password]
      flash[:password] = nil

      #password must include one of #$!
      if !@password.include?("$") && !@password.include?("#") && !@password.include?("!")
        flash.now[:password] = "Your password must include at least one of the following: $, #, !"

      #check if password contains at least one digit using helper function containsDigit
      elsif !self.containsDigit @password
        flash.now[:password] = "Your password must contain at least one digit"

      #check if password contains at least one uppercase and one lowercase letter using helper function checkCase
      elsif !self.checkCase @password
        flash.now[:password] = "Your password must contain at least one uppercase and one lowercase letter"

      else
        #if both user id and password are valid, the user id cookie is deleted and we set @bothvalid to true in order to display the valid statement in the html
        @bothvalid = true
        cookies.delete(:user_id)
      end
    end
  end

  #helper function to determine if a string has a digit
  def containsDigit str
    ("0".."9").each {|x|
      result = str.include?(x)
      if (result)
        return true
      end
    }
    return false
  end

  #helper function to determine if a string has an uppercase and lowercase letter
  def checkCase str
    if str.upcase == str || str.downcase == str
      return false
    else
      return true
    end
  end
end
