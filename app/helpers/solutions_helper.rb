module SolutionsHelper
  # Generates the link box for the difficulty level
  def difficulty_box(id,main_title,sub_title,link,disabled=false)
    if disabled
      raw("<div id=\"#{id}\" class=\"difficulty disabled\"><h3>#{main_title}</h3><p>#{sub_title}<p></div>")
    else
      raw("<div id=\"#{id}\" class=\"difficulty\" onclick=\"navigate('#{link}');\"><a href=\"#{link}\"><h3>#{main_title}</h3></a><p><a href=\"#{link}\">#{sub_title}</a><p></div>")
    end
  end

  def goal_markup(has_goal,goal_met,goal,goal_type,new,no_goal_text)
    klass = ""
    unless new
      if has_goal
        if goal_met
          klass = "satisfied"
        else
          klass = "unsatisfied"
        end
      else
        klass = "nogoal"
      end
    end
    if has_goal
      raw("<div class=\"one-goal #{klass}\">#{goal_text(goal,goal_type)}</div>")
    else
      raw("<div class=\"one-goal #{klass}\">#{no_goal_text}</div>")
    end
  end

  def goal_text(goal,goal_type)
    if goal_type == :carl_goal_met?
      "Bring C.A.R.L. to #{goal.carl[0]},#{goal.carl[1]}"
    elsif goal_type == :beacons_goal_met?
      "Place beacons at " + goal.beacons.map{ |b| "#{b[0]},#{b[1]}" }.join("; ")
    elsif goal_type == :lines_of_code_goal_met?
      "Do this in #{goal.lines_of_code} lines of code or less"
    end
  end
end
