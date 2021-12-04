class AppointmentController < ApplicationController

    def new
        @appointment = Appointment.new
        @hours = hours
        @users = User.where(role: 1)
    end

    def create
      byebug

      @appointment = Appointment.new(appo_params)
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

    def destroy
    end

    def update
    end

    def appo_params
      params.require(:appointment).permit(:professional_id, :user_id, :hour, :date)
    end
end
