module SolutionsHelper
  # Generates the link box for the difficulty level
  def difficulty_box(id,main_title,sub_title,link,disabled=false)
    if disabled
      raw("<div id=\"#{id}\" class=\"difficulty disabled\"><h3>#{main_title}</h3><p>#{sub_title}<p></div>")
    else
      raw("<div id=\"#{id}\" class=\"difficulty\" onclick=\"navigate('#{link}');\"><a href=\"#{link}\"><h3>#{main_title}</h3></a><p><a href=\"#{link}\">#{sub_title}</a><p></div>")
    end
  end
end
