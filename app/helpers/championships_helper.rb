module ChampionshipsHelper

  def render_brackets(championship)
    html = "<ul>"
    html += render_node(championship.full_loaded_final)
    html += "</ul>"
    html.html_safe
  end

  def render_node(node)
    html = "<li>"
    if(node.player_1.present? && node.player_1.present?)
      if(node.finished?)
        html += "<span>"+node.player_1.user.name+" x "+node.player_2.user.name+"</span>"
      else
        html += "<span>"
        html += "<a href='#'>"+node.player_1.user.name+"</a>"
        html += " x "
        html += "<a href='#'>"+node.player_2.user.name+"</a>"
        html += "</span>"
      end
    else
      html += "<span>? x ?</span>"
    end
    if (node.children.count > 0)
      html +=  "<ul>"
      node.children.each do |child|
        html += render_node(child)
      end
      html += "</ul>"
    end
    html += "</li>"
  end

end
