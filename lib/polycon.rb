module Polycon
  autoload :VERSION, 'polycon/version'
  autoload :Commands, 'polycon/commands'
  require_relative 'polycon/helpers/helpers.rb'
  require_relative 'polycon/classes/Appointment.rb'
  require_relative 'polycon/classes/Professional.rb'
  require_relative 'polycon/templates/templates.rb'

  # Agregar aquí cualquier autoload que sea necesario para que se cargue las clases y
  # módulos del modelo de datos.
  # Por ejemplo:
  # autoload :Appointment, 'polycon/appointment'
end
