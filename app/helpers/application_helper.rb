module ApplicationHelper
include Att::Codekit


VALID = ["Amex","Freedom","Travel","Cash","Jcp","Express"]
VALID_GOOD_NEG = ["Credit Cards","Savings"]
ERROR = "#FF0000"
NEUTRAL = "#FFFFFF"
SUCCESS = "#00FFFF"

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

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

  def good_pos_cell_color(amount = 0, debt_name = "")
    if VALID_GOOD_NEG.include?(debt_name)
       good_neg_cell_color(amount)
     else
       amount < 0 ? ERROR : NEUTRAL
     end
  end

  def good_neg_cell_color(amount = 0, debt_name = nil)
    debt = Debt.find_by_name(debt_name)

    if !debt.nil?
      (amount > 0 && VALID.include?(debt.name) )? ERROR : NEUTRAL
     else
        NEUTRAL
     end
  end

  def equal_cell_color(amount_1 = nil, amount_2 = nil, alert = true)
    if !(amount_1.nil? || amount_2.nil?)
      amount_1 == amount_2 ? alert ? SUCCESS : NEUTRAL : ERROR
    end
  end

  def auth_service
    service = Auth::AuthCode.new(ATT_CONFIG['fqdn'], ATT_CONFIG['client_id'], ATT_CONFIG['client_secret'], :redirect => root_url, :scope => ATT_CONFIG['scope'])
  end

  def text_token
    token = Auth::OAuthToken.open_token(ATT_CONFIG['token_file']) if File.exist?(ATT_CONFIG['token_file'])
  end

  def store_token(code = nil)
    if code
      token = auth_service.createToken(code)
      Auth::OAuthToken.save_token(ATT_CONFIG['token_file'], token)
    end
  end

  def text_service
    if text_token
      Service::IMMNService.new(ATT_CONFIG['fqdn'], text_token)
    end
  end
end
