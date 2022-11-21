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

  
end
