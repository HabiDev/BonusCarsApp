module ApplicationHelper
  # include Pagy::Frontend
  ALERTS = { alert: 'warning', 
             notice: 'info',
             success: 'success',
             error: 'danger' }.freeze

  STASUS = {  registred: 'info',  
              success: 'success', 
              unsuccess: 'danger', 
              executed: 'success',              
              delayed: 'warning',
              canceled: 'dark' }.freeze
 
  def status_manager(key)
    STASUS[key.to_sym] || key
  end

  def text_status(resource)
    enum_l(resource, :status)
  end
  
  def alert_manager(key)
    ALERTS[key.to_sym] || key
  end

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info"
      when 'success' then "alert alert-success"
      when 'error' then "alert alert-danger"
      when 'alert' then "alert alert-warning"
      when 'danger' then "alert alert-danger"
      when 'warning' then "alert alert-warning"
    end
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash", partial: "shared/flash"
  end

end
