module ApplicationHelper
  def active_for(controller_name)
    if(controller_name == self.controller_name)
      'active'
    else
      ''
    end
  end
end
