module SolutionsHelper
  # Generates the link box for the difficulty level
  def difficulty_box(id,main_title,sub_title,link,disabled=false)
    if disabled
      raw("<div id=\"#{id}\" class=\"difficulty disabled\"><h3>#{main_title}</h3><p>#{sub_title}<p></div>")
    else
      raw("<div id=\"#{id}\" class=\"difficulty\" onclick=\"navigate('#{link}');\"><a href=\"#{link}\"><h3>#{main_title}</h3></a><p><a href=\"#{link}\">#{sub_title}</a><p></div>")
    end
  end

  def render_code(code,last_line_executed,exploded)
    @indent = ""
    do_render(code,last_line_executed,exploded)
  end

  def do_render(code,last_line_executed,exploded)
    last_line_executed += 1
    html = ""
    code.nil? || code.each do |line|
      if line.kind_of? Branch
        html << render_one_line(line.class.command_name,last_line_executed,exploded) + "\n"
        html << do_render(line.code,last_line_executed,exploded) + "\n"
        html << render_one_line("end",last_line_executed,exploded) + "\n"
        @counter += line.code.size + 2 # one for the control, one for the end
      else
        html << render_one_line(line,last_line_executed,exploded)
        html << "\n"
        @counter += 1
      end
    end
    raw(html)
  end

  def render_one_line(line,last_line_executed,exploded)
    div = ""
    executed = last_line_executed >= @counter ? 'executed' : ''
    final_line = last_line_executed == @counter
    explode = final_line && exploded
    text = ""
    symbol = nil
    indent = @indent
    case line
    when 'move'
      symbol = "2191"
    when 'turnleft'
      symbol = "21B0"
    when 'pickbeacon'
      symbol = "21F1"
    when 'putbeacon'
      symbol = "21F2"
    when 'iterate'
      symbol = "21C8"
      text = " 3 times"
      indent += " "
    when 'loop'
      symbol = "21BA"
      text = " while front is clear"
      indent += " "
    when 'branch'
      symbol = "21B9"
      text = " if front is clear"
      indent += " "
    when 'end'
      @indent.sub!(' ','')
    end
    div = <<EOF
<div id="#{ @counter }_#{ line }" class="#{ line } #{ explode ? 'explode' : executed }">
    #{@indent.gsub(' ','&nbsp;')}
    #{ symbol.nil? ? '' : raw("&#x#{symbol};") } #{line}#{text}
    #{executed == '' ? '' : final_line ? " &#x2717;" : " &#x2713;" }
</div>
EOF
    @indent = indent
    div
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
