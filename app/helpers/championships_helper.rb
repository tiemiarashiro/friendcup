module ChampionshipsHelper

  def render_brackets(championship)
    html = "<ul>";
    html += render_node(championship.full_loaded_final, html)
    html += "</ul>";
  end

  def render_node(node, html)
    html += "<li>"
    html += "<a>"+node.name+"</a>"
    if (node.children.count > 0)
      html +=  "<ul>";
      node.children.each do |child|
        render_node(child, html);
      end
      html +=  "</ul>";
    end
    html +=  "</li>";
  end

end
