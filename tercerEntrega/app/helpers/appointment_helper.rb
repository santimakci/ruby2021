module AppointmentHelper

	def self.normalize_html html
    replacements = {
      "&lt;" => "<",
      "&gt;" => ">"
    }
    keys = Regexp.union(replacements.keys)
    return html.gsub(keys, replacements)
  end

  def self.html_in_date data, headers, *options
      if options.empty? 
        title = "Report" 
      else 
        title = options[0] 
      end
      xm = Builder::XmlMarkup.new(:indent => 2)
      xm.html {                    
        xm.head {                   
          xm.style("table, th, td {
            border: 1px solid black;
            margin: auto;
            text-align: center;
          }
          h1 {
            text-align: center;
            }")       
          }                           
          xm.body { 
          xm.h1 ( title ) 
          xm.table {
            xm.tr { headers.each { |key| xm.th(key)}}
            data.each { |row| xm.tr { row.values.each { |value| xm.td(value)}}}
          }
        }
      }
      return xm.target!  
  end
    
  def self.export_for_date date, hours
    data = []
    headers = ["", date]
    professionals = Professional.all
    appointments = Appointment.where(date: date)
    for h in hours
      names = ''
			for appo in appointments 
				patient_name = ''
				if appo.hour.to_s(:time) == h 
        	patient_name += "#{appo.user.email} (#{appo.professional.nameAndSurname})"
        	names += (patient_name +"<br>")
				end
      end
      if names != ''
        data.push( {hour: h, date: names})
      end
    end
		if data.empty?
			data.push( {hour: "-", date: "No hay turnos para la fecha indicada"})
		end
    self.html_in_date data, headers, date
  end

	def self.export_for_professional_in_date appointments, date, professional
    data = []
    headers = ["", date]
    for appo in appointments
      patient_name = "#{appo.user.email}"
      data.push( {hour:appo.hour.to_s(:time), date:patient_name})
    end
    if data.empty?
			data.push( {hour: "-", date: "No hay turnos para la fecha indicada y el profesional"})
		end
		self.html_in_date data, headers, professional
  end

	def self.export_week date, appointments, *options
    days = []
    data = []
		date_parsed = date
    for i in 0..6
      days.push(date_parsed.strftime('%F')) 
      date_parsed = date_parsed + 1
    end
    appointments_addeds = []
		hours = []
		for appo in appointments
			hour = appo.hour.to_s(:time)
      if !(hours.include? hour)
        hours.push(hour)
      end
    end
    hours = hours.sort
    for h in hours
			dict = {hour:h}
      for d in 0..6
				current_date = date + d.days
        names = ''
				for appo in appointments
					if !appointments_addeds.include? appo and current_date == appo.date and appo.hour.to_s(:time) == h
						appointments_addeds.push(appo)
						patient_name = "#{appo.user.email} (#{appo.professional.nameAndSurname})"
            names += (patient_name +"<br>")
          	dict[d] = names
        	else
						if names == ''
            	dict[d] = "-"
						end
        	end
      	end
			end
			data.push(dict)
    end 
    days.unshift("")
		if options.empty? 
			title = date.strftime('%F') 
		else 
			title = options[0] 
		end
    self.html_in_date data, days, title
  end


		
    
end
