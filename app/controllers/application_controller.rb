class ApplicationController < ActionController::Base

  def render_not_found(status=:not_found)
    return render plain: "#{status.to_s.titleize}", status: status
  end

end
