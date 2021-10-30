class Appointment
    extend Helpers
    require 'fileutils'
    require 'date'
    require 'builder'

  def self.create_appointment date, professional, name, surname, phone, notes
    name_appointment = date.tr(" ", "_")
    date_with_timezone = date + "-03:00"
    parseable = DateTime.strptime(date_with_timezone, '%Y-%m-%d %H:%M %Z') rescue false
    if parseable == false
      return puts "Error: Date is not parseable"
    end
    if DateTime.strptime(date_with_timezone, '%Y-%m-%d %H:%M %Z') < DateTime.now
      return puts "Date should be equal or greater than today"
    end
    if !professional_exist? professional or appointment_exist? professional, name_appointment
      return puts "Professionals doesn't exists or appointment already exists"
    end
    File.open("#{system_dir}/#{professional}/#{name_appointment}.paf", "w") do |f|     
      f.write("#{name} \n#{surname} \n#{phone} \n#{notes}") 
      f.close
    end
    puts "Appointment created correctly"
  end
      
  def self.show_information date, professional
    name_appointment = date.tr(" ", "_")
    if !professional_exist? professional or !appointment_exist? professional, name_appointment
      return puts "Professionals doesn't exists or appintment doens't exists"
    end
    file = File.open("#{system_dir}/#{professional}/#{name_appointment}.paf") 
    puts file.read  
  end

  def self.cancel_appointment date, professional
    name_appointment = date.tr(" ", "_")
    if !professional_exist? professional or !appointment_exist? professional, name_appointment
      return puts "Professionals doesn't exists or appointment doesn't exists"
    end
    FileUtils.rm_r "#{system_dir}/#{professional}/#{name_appointment}.paf"
    return puts "Appointment has been deleted"
  end

  def self.cancel_all professional
    if !professional_exist? professional
      return puts "Professional doesn't exists"
    end
    FileUtils.rm_rf "#{system_dir}/#{professional}/.", secure: true
    puts "All appointments from #{professional} have been deleted"
  end 

  def self.reschedule old_date, new_date, professional
      name_new_appointment = new_date.tr(" ", "_")
      name_old_appointment = old_date.tr(" ", "_")
      if !professional_exist? professional or !appointment_exist? professional, name_old_appointment
          return puts "Professionals doesn't exists or appointment doesn't exists"
      end
      if appointment_exist? professional, name_new_appointment
          return puts "There is already an appointment in that date"
      end
      File.rename("#{system_dir}/#{professional}/#{name_old_appointment}.paf", "#{system_dir}/#{professional}/#{name_new_appointment}.paf")
      puts "The appointment was changed to #{new_date}"
  end
	
  def self.list professional, date
    if !date.nil?
      name_appointment = date.tr(" ", "_")
    end
    if !professional_exist? professional
      return puts "Professional doesn't exists"
    end
    Dir.foreach("#{system_dir}/#{professional}/") do |file|
      if file != "." && file != ".."  
				if date.nil?
        	puts file.chomp(".paf").tr("_", " ")
				elsif file.include? name_appointment
						puts file.chomp(".paf").tr("_", " ")
				end
      end
    end
  end

  def self.edit_appointment date, professional, options
    name_appointment = date.tr(" ", "_")
    if !professional_exist? professional or !appointment_exist? professional, name_appointment
      return puts "Professionals doesn't exists or appointment doesn't exists"
    end
    lines = File.readlines("#{system_dir}/#{professional}/#{name_appointment}.paf")
    File.foreach("#{system_dir}/#{professional}/#{name_appointment}.paf").with_index do |line, line_num|
      case line_num
      when 0
        if options.key? :name
          lines[line_num] = "#{options[:name]}\n"
        end
      when 1
        if options.key? :surname
          lines[line_num] = "#{options[:surname]}\n"
        end
      when 2
	      if options.key? :phone
          lines[line_num] = "#{options[:phone]}\n"
        end
      when 3
        if options.key? :notes
          lines[line_num] = "#{options[:notes]}\n"
        end
      end
      File.open("#{system_dir}/#{professional}/#{name_appointment}.paf", 'w') { |f| f.write(lines.join) }
    end
    puts "The appointment was modified correctly"
  end

  #############################exports######################################

  def self.export options
    professional = options[:professional]
    date = options[:date]
    export_week = options[:week]
    if export_week.nil? or export_week == "false"
      if date and professional
        self.export_for_professional_in_date professional, date
      elsif date and !professional
        self.export_for_date date
      end
    elsif
      if date and professional
        self.export_week_for_professional professional, date
      elsif date and !professional
        self.export_week date
      end
    end
  end


  def self.list_for_professional professional
    appointments = []
    Dir.foreach("#{system_dir}/#{professional}/") do |file|
      if file != "." && file != ".." && file != "export.html"
        appointments.push( file.chomp(".paf"))
      end
    end
    return appointments.sort
  end

  def self.list_all_appointments
    appointments = []
    Dir.foreach(system_dir) do |dir|
      if File.directory?("#{system_dir}/#{dir}") && dir != "." && dir != ".." && dir != "exports_by_date"
        Dir.foreach("#{system_dir}/#{dir}/") do |file|
          if file != "." && file != ".." && file != "export.html"
            appointments.push( file.chomp(".paf"))
          end
        end
      end
    end
    return appointments.sort
  end

  ###############################EXPORTS WEEKS#####################################

  def self.export_week_for_professional professional, date
    date_parsed = DateTime.strptime(date, '%Y-%m-%d')
    days = []
    data = []
    for i in 0..6
      days.push(date_parsed.strftime('%F')) 
      date_parsed = date_parsed + 1
    end
    appointments = self.list_for_professional professional
    hours = []
    for appo in appointments
      hour = appo.split("_").last
      if !(hours.include? hour.strip)
        hours.push(hour.strip)
      end
    end
    hours = hours.sort
    for h in hours 
      dict = {hour:h}
      days.each_with_index do |day, index|
        name_file = day + "_" + h
        if appointments.include? name_file
          patient_name = File.open("#{system_dir}/#{professional}/#{name_file}.paf", &:readline)
          dict[day] = patient_name + "(#{professional})"
        else
          if day.size != 1
            dict[day] = "-"
          end
        end
      end
      data.push(dict)
    end
    days.unshift("")
    self.create_html_for_professional_in_date data, days, professional
    puts "Export from #{professional} in week #{date} was created"
  end

  def self.export_week date  
    date_parsed = DateTime.strptime(date, '%Y-%m-%d')
    professionals = Professional.get_array_professionals
    days = []
    data = []
    for i in 0..6
      days.push(date_parsed.strftime('%F')) 
      date_parsed = date_parsed + 1
    end
    appointments = self.list_all_appointments
    appointments_addeds = []
    hours = []
    for appo in appointments
      hour = appo.split("_").last
      if !(hours.include? hour.strip)
        hours.push(hour.strip)
      end
    end
    hours = hours.sort
    puts hours
    for h in hours
      dict = {hour:h}
      days.each_with_index do |day, index|
        names = ''
        name_file = day + "_" + h
        if appointments.include? name_file and !appointments_addeds.include? name_file
          appointments_addeds.push(name_file)
          for prof in professionals
            if File.exist?("#{system_dir}/#{prof}/#{name_file}.paf")
              patient_name = File.open("#{system_dir}/#{prof}/#{name_file}.paf", &:readline)
              patient_name = patient_name + " (" + prof + ")"
              names += (patient_name +"<br>")
            end
          end
          dict[day] = names
        else
          if day.size != 1
            dict[day] = "-"
          end
        end
      end
      data.push(dict)
    end 
    days.unshift("")
    self.create_html_in_date data, days, date
    puts "Export from #{date} was created"
  end

  #############################EXPORT FOR PROFESSIONAL IN DATE###################

  def self.export_for_professional_in_date professional, date
    data = []
    headers = ["", date]
    for h in hours
      name_file = date + "_" + h
      if appointment_exist? professional, name_file
        patient_name = File.open("#{system_dir}/#{professional}/#{name_file}.paf", &:readline)
        patient_name += "(#{professional})"
        data.push( {hour:h, date:patient_name})
      end
    end
    if data.empty? 
      return puts "Professional has not appointments for this date"
    end
    self.create_html_for_professional_in_date data, headers, professional
    puts "Export from #{professional} was created"
  end

  def self.create_html_for_professional_in_date data, headers, professional
    html = html_in_date data, headers, professional
    File.open("#{system_dir}/#{professional}/export.html", "w") do |f|     
        f.write(html) 
        f.close
      end
  end

  #############################IMPORT IN DATE###################

  def self.export_for_date date
    data = []
    headers = ["", date]
    professionals = Professional.get_array_professionals
    appointments = []
    for h in hours
      name_file = date + "_" + h
      for professional in professionals
        patient_name = ''
        if appointment_exist? professional, name_file
          appointments |= [name_file]
        end
      end
    end
    for h in hours
      names = ''
      name_file = date + "_" + h
      for professional in professionals
        for appo in appointments 
          if appointment_exist? professional, name_file and name_file == appo
            patient_name = File.open("#{system_dir}/#{professional}/#{appo}.paf") {|f| f.readline}
            patient_name += "(#{professional})"
            names += (patient_name +"<br>")
          end
        end
      end
      if names != ''
        data.push( {hour: h, date: names})
      end
    end
    if data.empty? 
      return puts "There are not professionals in this date"
    end
    self.create_html_in_date data, headers, date
    puts "Export from #{date} was created"
  end

  def self.create_html_in_date data, headers, date
    html = html_in_date data, headers
    html = normalize_html html
    name = "Export" + date
    File.open("#{system_dir}/exports_by_date/#{name}.html", "w") do |f|     
        f.write(html) 
        f.close
    end
  end

end