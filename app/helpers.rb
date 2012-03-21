module Helpers
  def link_to(text, model)
    if model.is_a? Document
      href = "/documents/#{model.slug}"
    elsif model.is_a? String
      href = model
    end

    "<a href='#{href}'>#{text}</a>"
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
end