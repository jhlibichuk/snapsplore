class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :provider, :uid, :auth_token
  devise :omniauthable, :omniauth_providers => [:facebook]

  has_many :entries

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    
    # FB Won't give me email in production. Fine. We fake it.
    #puts "Auth Info Email: #{auth.info.email}"
    #puts "Auth Info Id: #{auth.uid}"

    email = auth.info.email
    email = "#{auth.uid}@facebook.com" if email.blank?
    if user
      return user
    else
      registered_user = User.where(:email => email).first
      if registered_user
        return registered_user
      else
        user = User.create!(name: auth.extra.raw_info.name,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:email,
                            password:Devise.friendly_token[0,20]
                          )
      end
    end
  end


  def solved(list_item)
    return "solved" if self.has_entered(list_item)
    return ""
  end

  def has_entered(list_item)
    return true if Entry.where(user_id:self.id, list_item_id: list_item.id).present?
    return false
  end

  def get_entry(list_item)
    return Entry.where(user_id:self.id, list_item_id: list_item.id).first
  end

end
