module WelcomeHelper
  # Generates the link box and all that that requires
  def link_box(id,main_title,sub_title,text,link)
    html = <<EOF
    <div id="#{id}" onclick="navigate('#{link}');">
      <h2><a href="#{link}">#{main_title}</a></h2>
      <h3><a href="#{link}">#{sub_title}</a></h3>
      <p>
      #{text}
      </p>
    </div>
EOF
    raw(html)
  end
end
