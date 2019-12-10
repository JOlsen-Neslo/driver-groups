module UsersHelper
  def gravatar_for(user, size = 50)
    gravatar_id = Digest::MD5::hexdigest(user.username.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.person.name.value, class: "gravatar", size: size)
  end
end
