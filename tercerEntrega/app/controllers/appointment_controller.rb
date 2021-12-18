class AppointmentController < ApplicationController
    before_action :set_appointment, only: [:destroy, :edit, :update, :show]
    before_action :appointments_authorized

    def new
        @appointment = Appointment.new
        @hours = hours
        @users = User.where(role: 1)
        @professionals = Professional.all
    end

    def show
    end

    def create
      @appointment = Appointment.new(appo_params)
      byebug
      if appo_params[:date].empty?
        respond_to do |format|
          format.html { redirect_to new_appointment_path, flash:{success: false, messages: "Debe seleccionar una fecha" } }
        end
      else
        @appointment.date = Date.strptime(appo_params[:date], "%m/%d/%Y")
        respond_to do |format|
          begin
            if @appointment.save
              format.html { redirect_to new_appointment_path, flash:{success: true, messages: "Turno creado con éxito" } }
            else
              format.html { redirect_to new_appointment_path, flash:{success: false, messages: "Error al crear el turno" } }
            end
          rescue Exception
            format.html { 
              redirect_to new_appointment_path,
              flash:{success: false, messages: "Error al crear el turno, verifique que no exista ya un 
                  turno para ese usuario o profesional en la fecha indicada" } }
          end
        end
      end
    end

    def destroy
      @professional_id = @appointment.professional_id
      @appointment.destroy
      respond_to do |format|
        format.html { redirect_to professional_path(@professional_id), flash:{success: true, messages: "Se eliminó el turno con éxito" }}
      end
    end

    def update
      @appointment = Appointment.find(params[:id])
      if appo_params[:date].empty?
        redirect_to appointment_path(@appointment.id), flash:{success: false, messages: "Debe seleccionar una fecha" }
      end
      appo_params[:date] = Date.strptime(appo_params[:date], "%m/%d/%Y")
      respond_to do |format|
        begin
          if @appointment.update(appo_params)
            format.html { redirect_to appointment_path(@appointment.id), flash:{success: true, messages: "Turno actualizado con éxito" } }
          else
            format.html { redirect_to appointment_path(@appointment.id), flash:{success: false, messages: "Error al actualizar el turno" } }
          end
        rescue Exception
          format.html { 
            redirect_to  appointment_path(@appointment.id),
            flash:{success: false, messages: "Error al actualizar el turno, verifique que no exista ya un 
                turno para ese usuario o profesional en la fecha indicada" } }
        end
      end
    end

    def edit 
      @hours = hours
      @users = User.where(role: 1)
      @professionals = Professional.all
    end
    
    def appo_params
      params.require(:appointment).permit(:professional_id, :user_id, :hour, :date)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end


    ## Export logic 

    def export
      @professionals = Professional.all
    end

    def create_export
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
      download AppointmentHelper.normalize_html html
    end
    
    def export_day
      date = params[:date] = Date.strptime(params[:date], "%m/%d/%Y")
      if params[:professional_id].empty?
        AppointmentHelper.export_for_date date, hours
      else
        appointments = Appointment.where(professional_id: params[:professional_id], date: date)
        profesional = Professional.find(params[:professional_id])
        AppointmentHelper.export_for_professional_in_date appointments, date, profesional.nameAndSurname
      end
    end
  
    
    def export_week
      date = params[:date] = Date.strptime(params[:date], "%m/%d/%Y")
      if params[:professional_id].empty?
        appointments = Appointment.where(date: date.beginning_of_week..date.end_of_week).order(:date, :hour)
        AppointmentHelper.export_week date.beginning_of_week, appointments
      else
        appointments = Appointment.where(professional_id: params[:professional_id], date: date.beginning_of_week..date.end_of_week)
        professional = Professional.find(params[:professional_id])
        AppointmentHelper.export_week date.beginning_of_week, appointments, professional.nameAndSurname
      end
    end
    
    def download html
      File.delete(path_to_file) if File.exist?(path_to_file)
      File.open(path_to_file, "w") do |f|     
          f.write(html) 
          f.close
      end
      send_file path_to_file, :type => "text/html", :disposition => 'attachment'
    end
  
    def export_params
      params.require(:export).permit(:date)
    end

    def path_to_file
      "#{Rails.root}/public/export.html"
    end
  
end
