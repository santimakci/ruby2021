# Polycon

Plantilla para comenzar con el Trabajo Práctico Integrador de la cursada 2021 de la materia
Taller de Tecnologías de Producción de Software - Opción Ruby, de la Facultad de Informática
de la Universidad Nacional de La Plata.

Polycon es una herramienta para gestionar los turnos y profesionales de un policonsultorio.

Este proyecto es simplemente una plantilla para comenzar a implementar la herramienta e
intenta proveer un punto de partida para el desarrollo, simplificando el _bootstrap_ del
proyecto que puede ser una tarea que consume mucho tiempo y conlleva la toma de algunas
decisiones que más adelante pueden tener efectos tanto positivos como negativos en el
proyecto.

## Uso de `polycon`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/polycon`,
el cual puede correrse de las siguientes manera:

```bash
$ ruby bin/polycon [args]
```

## Ejemplos de los comandos disponibles 

### CRUD Professionals

#### Create

```bash
$ ruby bin/polycon p create Santiago
```

#### Delete 

```bash
$ ruby bin/polycon p delete Santiago
```

#### Rename
 
first param is old name, second param is new name

```bash
$ ruby bin/polycon p rename Santiago Santi
```


### CRUD Appointments

#### Create 

```bash
$ ruby bin/polycon a create "2022-10-16 13:00" --professional="Maki" --name=Santiago --surname=Makcimovich --phone=2213334567 --notes="nota extra"

```

#### Show appointment

```bash
$ ruby bin/polycon a show "2022-10-16 13:00" --professional="Maki"
```

#### Cancel

```bash
$ ruby bin/polycon a cancel "2022-10-16 13:00" --professional="Maki"
```


#### Cancel all

```bash
$ ruby bin/polycon a cancel-all Maki
```

#### List 

If date is not sent, it is going to be listed from professional

```bash
ruby bin/polycon a list "Maki" --date="2022-10-16"
```

#### Reschedule

```bash
ruby bin/polycon a reschedule "2022-10-16 13:00" "2022-10-16 18:00" --professiona="Maki"
```


#### Edit 

```bash
ruby bin/polycon a edit "2022-10-16 18:00" --professional="Maki" --name="Santiago" --surname="Makcimovich" --phone="00000000" --notes="Notaaa editada"
```