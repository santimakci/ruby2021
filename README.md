# Polycon

## CORRECCIONES

 - Se acomodó la lógica de los controller para utilziar el before action de manera correcta y evitar escribir código extra
 - Se eliminó el controller de exports y se movió la lógica al controller de appointments
 - Se generó un script en seed para crear usuarios, turnos y profesionales 
 - Se corrigió la descarga de archivos que bloqueaba el botón una vez presionado 
## Tercer entrega

En esta entrega se implementó el uso de ruby on rails para el manejo de turnos y profesionales.
Se utilizó Mysql 8 para la implementación de la base de datos creada a base de migraciones. 

El proyecto cuenta con usuarios que pueden ser de 3 tipos

Administrador, tiene rol número 3 en la base de datos
Asistente, tiene rol número 2 en la base datos
Paciente, tiene rol número 1 en la base de datos

Dependiendo del rol que tengan asignados podrán hacer diferentes funcionalidades en el sistema. 

Los turnos se crean asignando una hora, una fecha, un profesional y un paciente (usuario paciente)

Se crearon index para evitar que un profesional o paciente tengan un turno a la misma hora el mismo día. 

Ya que la entrega 3 no especifícaba los datos de cada tabla se usaron datos genéricos, para los usuarios, se utilizó el email como dato principal, para profesionales nombre y apellido único en el sistema. Respecto a los horarios de los turnos se definió un arreglo que contenía los horarios disponibles en los cuales se podía pedir turnos. 

Para el estilo de la página se utilizó boostrap y jquery para crear un datepicker para poder elegir la fecha. 

Respecto a los export se utilizó la gema builder para construir los archivos html más fácilmente, Los archivos se crean y quedan hasta que se realice otro export, donde serán eliminados y suplantados. 
Respecto a la funcionalidad de exportar hay que tener en cuenta que el send_file funciona como response del controller por ende no se puede aplicar un redirect_to o algo similar sin tener que usar otra tecnología como javascript por eso es que luego de exportar turnos, el botón queda bloqueado sin indicar un mensaje de error o éxito.
Además la funcionalidad de exportar turnos es permitida a todos los usuarios adrede ya que la consigna no especificaba quienes podrían hacer esto. 

En cuanto a la entrega 2, se reutilizó gran parte del código, principalmente la creación de las grillas de turnos, solamente cambiando las partes que buscaban la información de los turnos y profesionales siendo suplantadas por las consultas hechas con el ORM de rails. 
Además se corrigieron errores de la entrega 2, por ejemplo que cuando se indica una fecha se arme la grilla en base al primer día de la semana de la fecha indicada, es decir arrancando del último lunes de la fecha dada.

Registrándose en el sistema se puede crear un usuario genérico que por defecto va a ser de tipo paciente, cambiandole el rol por base al número que corresponda se puede crear un usuario administrador o asistente según corresponda. 






