module ApplicationHelper
  include Pagy::Frontend

  def gravatar_for(user, options = { size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.username, class: "img-circle")
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :alert
      'alert-danger'
    when :notice
      'alert-success'
    else
      flash_type.to_s
    end
  end
end
