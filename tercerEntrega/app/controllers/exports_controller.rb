class ExportsController < ApplicationController
  include ExportsHelper

  def new
    @professionals = Professional.all
  end

  def download html
    File.delete(path_to_file) if File.exist?(path_to_file)
    File.open(path_to_file, "w") do |f|     
        f.write(html) 
        f.close
    end
    send_file path_to_file, :type => "text/html", :disposition => 'attachment'
  end

  def create
    if params[:date].empty?
      respond_to do |format|
          format.html { redirect_to new_export_path, flash:{success: false, messages: "Por favor ingrese una fecha" } }
      end
    end
    if params[:weekly] == "true"
      html = export_week
    else
      html = export_day
    end
    download ExportsHelper.normalize_html html
  end

  def export_day
    date = params[:date] = Date.strptime(params[:date], "%m/%d/%Y")
    if params[:professional_id].empty?
      ExportsHelper.export_for_date date, hours
    else
      appointments = Appointment.where(professional_id: params[:professional_id], date: date)
      profesional = Professional.find(params[:professional_id])
      ExportsHelper.export_for_professional_in_date appointments, date, profesional.nameAndSurname
    end
  end


  def export_week
    date = params[:date] = Date.strptime(params[:date], "%m/%d/%Y")
    if params[:professional_id].empty?
      appointments = Appointment.where(date: date.beginning_of_week..date.end_of_week).order(:date, :hour)
      ExportsHelper.export_week date.beginning_of_week, appointments
    else
      appointments = Appointment.where(professional_id: params[:professional_id], date: date.beginning_of_week..date.end_of_week)
      professional = Professional.find(params[:professional_id])
      ExportsHelper.export_week date.beginning_of_week, appointments, professional.nameAndSurname
    end
  end


  def export_params
    params.require(:export).permit(:date)
  end

  def path_to_file
    "#{Rails.root}/public/export.html"
  end

end
