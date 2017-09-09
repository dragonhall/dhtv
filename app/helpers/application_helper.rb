module ApplicationHelper

  # @param [String] body
  # @param [String|Array] url
  # @param [Hash] html_options
  def navbar_item_link_to(body, url, html_options = {})
    if html_options.key?(:class)
      html_options[:class] << ' navbar-item'
    else
      html_options[:class] = 'navbar-item'
    end

    active = false

    if url.is_a?(String) and (url == request.url || url == request.path)
      STDERR.puts "String match! (#{url} == #{request.url} || #{url} == #{request.url})"
      active = true
    elsif url_for(url) == request.url
      STDERR.puts "url_for match! (url_for(#{url}) == #{request.url})"
      active = true
    end

    html_options[:class] << ' is-active' if active

    link_to body, url, html_options
  end

  def faw_icon(icon, options = {})
    text = options.delete(:text)
    text_options = options.delete(:text_options) || {}
    options[:class] = options.key?(:class) ? options[:class] + ' icon is-small' : 'icon is-small'

    (content_tag(:span, fa_icon(icon), options) +
        (text.blank? ? '' : content_tag(:span, text, text_options))).html_safe
  end

  def time_display(seconds)
    if seconds > 3599
      Time.at(seconds).utc.strftime('%T')
    else
      Time.at(seconds).utc.strftime('%M:%S')
    end
  end
end
