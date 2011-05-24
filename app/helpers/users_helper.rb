module UsersHelper

  def gravatar_for(user, ops={:size=>50})
    gravatar_image_tag (user.email.downcase, :class=>'gravatar',
                                                     :alt=>"Example User",
                                                     :gravatar=>ops)
  end
end
