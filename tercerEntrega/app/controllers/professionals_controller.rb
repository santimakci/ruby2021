class ProfessionalsController < ApplicationController
  before_action :set_professional, only: %i[ show edit update destroy ]
  before_action :admin_authorized, only: [:new, :edit, :destroy, :update, :create]

  # GET /professionals/1 or /professionals/1.json
  def show
    @professional = Professional.find(params[:id])
    @appointments = @professional.appointments.order(date: :asc, hour: :asc)
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
    @professional = Professional.find(params[:id])
  end

  # POST /professionals or /professionals.json
  def create
    @professional = Professional.new(professional_params)
    respond_to do |format|
      if @professional.save
        format.html { redirect_to root_path, flash:{success: true, messages: "Se creo el profesional con éxito" } }
      else
        format.html { redirect_to new_professional_path, flash:{success: false, messages: "Verifique el profesional no exista y haya completado la información" } }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to root_path, flash:{success: true, messages: "Profesional actualizado con éxito"} }
      else
        format.html { redirect_to edit_professional_path(@professional.id), flash:{success: false, messages: "No se pudo actualizar el profesional"} }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    if !@professional.appointments.empty?
      respond_to do |format|
        format.html { redirect_to root_path, flash:{success: false, messages:"No se puede eliminar el profesional porque tiene turnos asociados"} }
      end
    else
      @professional.destroy
      respond_to do |format|
        format.html { redirect_to root_path, flash:{success: true, messages:"Se eliminó el professional correctamente"} }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:nameAndSurname)
    end
end
