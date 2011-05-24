# == Schema Information
# Schema version: 20110517225030
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email,:password,:password_confirmation

  regex_for_email = /\A[\w\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence=>true,
                   :length => {:maximum => 50}
  validates :email, :presence=>true,
                    :format => regex_for_email,
                    :uniqueness => {:case_sensitive => false}
  validates :password, :presence => true,
                       :length => {:within=>6..40},
                       :confirmation => true

  before_save :password_encryption

       def has_right_password?(submitted_pwd)
         encrypted_password == encrypt(submitted_pwd)
       end

       def self.authenticate_user(email,password)
         user_local =  find_by_email(email)
         return nil if user_local.nil?
         return user_local if user_local.has_right_password?(password)
       end

  private

      def password_encryption
           self.salt = make_salt if new_record?
           self.encrypted_password = encrypt(password)
      end

      def encrypt(string)
         secure_hash("#{salt}--#{string}")
      end

      def make_salt
        secure_hash("#{Time.now.utc}--#{password}")
      end

      def secure_hash(string)
        Digest::SHA2.hexdigest(string)
      end
end
