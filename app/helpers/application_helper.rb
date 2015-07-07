module ApplicationHelper

# Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "My Money"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

# this is one way to define new instance methods
    ActionView::Helpers::FormBuilder.class_eval do
       def calendar_field(method, options = {})
         text_field(method, options.merge(class: 'datepicker'))
       end
    end

end
