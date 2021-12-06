class AppointmentController < ApplicationController
    before_action :set_appointment, only: %i[destroy, edit, update, show]
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
      set_appointment
      @professional_id = @appointment.professional_id
      @appointment.destroy
      respond_to do |format|
        format.html { redirect_to professional_path(@professional_id), flash:{success: true, messages: "Se eliminó el turno con éxito" }}
      end
    end

    def update
      set_appointment
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
      set_appointment
    end
    
    def appo_params
      params.require(:appointment).permit(:professional_id, :user_id, :hour, :date)
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end
end
