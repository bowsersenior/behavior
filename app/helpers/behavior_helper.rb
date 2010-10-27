module BehaviorHelper
  
  def behavior_tag(conf)
    case behavior_config.meta[conf][:type]
    when 'text'
      text_area_tag("conf[#{conf}]", behavior_config[conf], :id => conf)
    when 'password'
      password_field_tag("conf[#{conf}]", behavior_config[conf], :id => conf)
    when 'select'
      select_tag("conf[#{conf}]", options_for_select(behavior_config.meta[conf][:options]), :id => conf)
    else
      text_field_tag("conf[#{conf}]", behavior_config[conf], :id => conf)
    end
  end
end