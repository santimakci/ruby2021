class Appointment
    extend Global
    require 'fileutils'
    require 'date'


  def self.create_appointment date, professional, name, surname, phone, notes
    name_appointment = date.tr(" ", "_")
    if DateTime.strptime(date, '%Y-%m-%d %H:%M') < DateTime.now
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
end