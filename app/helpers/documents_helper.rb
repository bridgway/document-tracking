module DocumentsHelper
  def document_people_avatars(people)
    people.reduce "" do |html, person|
      html << image_tag(person.gravatar('25'))
    end.html_safe
  end

  def document_people_list(people)
    html = ""
    people.each_with_index do |person, i|
      name = person.name
      unless i == (people.size - 1)
        name << ", "
      end
      html << name
    end
    html
  end

  def public_discussion_link(user, document, text, opts = {})
    transfer = document.transfer
    url = File.join(user.id.to_s, "view", document.slug)
    if opts[:token]
      url << "?token=#{transfer.view_token}"
    end
    "<a href='#{url}'>#{text}</a>".html_safe
  end

  def document_status_header(document_status)
    if document_status == :signed
      status = "uigned"
    else
      status = "unsigned"
    end

    content_tag :h3, :class => status do
      "Status: #{status.capitalize}"
    end
  end

  def page_url_template(document_file)
    dir = document_file.source.file.basename
    size = '<%= size %>'
    basename = document_file.source.file.basename

    page = basename + "_" + '<%= page %>' + '.png'
    File.join("/uploads", dir, size, page)
  end
end