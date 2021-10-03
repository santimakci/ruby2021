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
            return puts "Professionals doesn't exists or appintment already exists"
        end
        File.open("#{system_dir}/#{professional}/#{name_appointment}.paf", "w") do |f|     
            f.write("#{name} \n#{surname} \n#{phone} \n#{notes}") 
            f.close
        end
        
        puts "Appointment created successy correctly"
    end
        

    def self.show_information date, professional
        name_appointment = date.tr(" ", "_")
        if !professional_exist? professional or !appointment_exist? professional, name_appointment
            return puts "Professionals doesn't exists or appintment doens't exists"
        end
        file = File.open("#{system_dir}/#{professional}/#{name_appointment}.paf") 
        puts file.read  
    end

end