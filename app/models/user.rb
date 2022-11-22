# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  validates :username, 
    length: {minimum: 4, maximum: 20},
    uniqueness: true,
    format: { without URI::MailTo::EMAIL_REGEXP, messsage: "Cannot be an Email"},
    presence: true
  
  validates :email,
    length: { in: 3..255 },
    uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP },
    presence: true
  
  validates :session_token,
   uniqueness: true,
   presence : true

  validates :password,
    length: {in 5..20},
    presence :true

  before_validation :ensure_session_token 

  # we are getting user input(fields) and checking to see if input matchess
  # any hit in our database. If so, we will log them in (which will be handled
  # in our contollers) else, we will return nil, and not get a match
  def self.find_by_credentials(credential ,password)
    if credential =~ URI::MailTo::EMAIL_REGEXP
      field = :email
      user = User.find_by(field => credential)
      user&.authenticate(password)
    else
      nil
    end
  end

  def reset_session_token!
    self.update!(session_token: generate_unique_session_token)
    self.session_token
  end

  private

  # generate new session token to a user. If there is a token that already
  # exists to another user, run function again until generated token is
  # unique

  def generate_unique_session_token
    loop do
      token = SecureRandom.base64
      break token unless User.exists?(session_token: token)
    end
  end

  # check to see if user already has a session token, if not, run
  # generate unique session token function and assign it to user

  def ensure_session_token
    self.session_token ||= generate_unique_session_token
  end
end
