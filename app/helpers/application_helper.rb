module ApplicationHelper
  def markdown(text)
    return "" if text.blank?

    options = {
      filter_html:     true, # Prevent direct HTML tag input (security)
      hard_wrap:       true, # Convert line breaks to <br> tags
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    # Sanitize the converted HTML to ensure safety
    sanitize(markdown.render(text)).html_safe
  end
end
