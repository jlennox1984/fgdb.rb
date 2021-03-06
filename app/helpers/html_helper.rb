module HtmlHelper
  def calendar_box(obj, field, options={}, ignored=nil)
    options[:class] = 'date-picker'
    text_field(obj, field, options)
  end

  def select_visibility(obj_name, method_name, choices = [], html_opts = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )

    # type choice
    display = "".html_safe
    display << %Q{<div class="form-element">}.html_safe
    display << select(obj_name,
                      method_name,
                      choices.map { |k,v|
                        [k.to_s.gsub(/_/, ' '), k.to_s]
                      }.sort_by(&:first))
    display << '</div>'.html_safe

    this_choice = obj.send(method_name)
    choices.each do |choice, content|
      if this_choice.to_s == choice.to_s
        visibility = ''
      else
        visibility = ' style="display:none;"'
      end
      c = %Q{<div id="%s_%s_%s_choice"} %
        [ obj_name, method_name, choice.to_s]
      c << %Q{class="form-element clear-left"}
      c << %Q{data-visibility-by="#%s_%s"%s>%s</div> } %
        [obj_name, method_name, visibility, content ]
      display << c.html_safe
    end

    return display.html_safe
  end

  DISPLAY_ALIAS = {:updated_at => 'last_updated_at', :updated_by => 'last_updated_by', :cashier_updated_by => 'last_cashier_updated_by'}

  def multiselect_of_form_elements(obj_name, choices = {}, mode = "auto")
    html = "<div id='#{obj_name}_container' class='conditions'>".html_safe
    js = "".html_safe
    for condition in choices.keys do
      html += hidden_field(obj_name, condition + "_enabled")
    end
    if mode == 'auto'
      if choices.length > 1
        mode = 'multi'
      else
        mode = 'force'
      end
    end
    if mode == 'multi' and choices.length == 0
      mode = 'force'
    end
    if mode == 'multi'
      choice_names = { }
      choices.each {|k,v| choice_names[k] = (DISPLAY_ALIAS[k.to_sym] || k).titleize}
      js = update_page do |page|
        page << "list_of_#{obj_name}_conditions = $H(#{choices.to_json.gsub("</script>", "<\\\/script>")});"
        page << "condition_#{obj_name}_display_names = $H(#{choice_names.to_json});"
        page.insert_html(:bottom, obj_name + "_container",
                         :partial => 'helpers/multiselection_header',
                         :locals => {:obj_name => obj_name})
        for condition in choices.keys.sort_by{|x| choice_names[x]} do
          page.insert_html(:bottom, obj_name + "_adder",
                           '<option id="%s_%s_option" value="%s">%s</option>' %
                           [obj_name, condition, condition, choice_names[condition]])
          page << "if($('#{obj_name}_#{condition}_enabled').value == 'true'){add_condition('#{obj_name}', '#{condition}');}"
        end
      end
      js += "$('#{obj_name}_nil').selected = true;".html_safe
    elsif mode == 'force'
      choices.each{|k,v|
        html += v
        js += "$('#{obj_name}_#{k}_enabled').value = 'true';"
      }
      if choices.length == 0
        js += "$('#{obj_name}_nil').selected = true;"
      end
    end
    html += "</div>".html_safe
    return html + javascript_tag(js)
  end

  # the object named "@#{obj_name}" must be able to respond to all the
  # fields listed below, or you should provide alternate fieldnames.
  def date_or_date_range_picker(obj_name, field_name)
    date_types = []
    obj = eval( "@#{obj_name}" )

    # daily
    date_types << ['daily', calendar_box(obj_name, field_name + '_date',{},{:showOthers => true})]
    # monthly
    date_types << ['monthly', select_month(obj.send(field_name + '_month'), :field_name => field_name + '_month', :prefix => obj_name) +
                   select_year(obj.send(field_name + '_year'), :prefix => obj_name, :field_name => field_name + '_year', :start_year => 2000, :end_year => Date.today.year)]
    date_types << ['quarterly', select(obj_name, field_name + '_quarter', (1..4).map{|x| ["Q" + x.to_s, x]})+ select_year(obj.send(field_name + '_year_q'), :prefix => obj_name, :field_name => field_name + '_year_q', :start_year => 2000, :end_year => Date.today.year)]
    date_types << ['yearly', select_year(obj.send(field_name + '_year_only'), :prefix => obj_name, :field_name => field_name + '_year_only', :start_year => 2000, :end_year => Date.today.year)]
    # arbitrary
    date_types << ['arbitrary', "From: %s To: %s" %
                   [ calendar_box(obj_name, field_name + '_start_date',{},{:showOthers => true}),
                     calendar_box(obj_name, field_name + '_end_date',{},{:showOthers => true}) ]]

    return select_visibility(obj_name, field_name + '_date_type', date_types)
  end
end
