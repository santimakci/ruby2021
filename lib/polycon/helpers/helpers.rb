module Polycon
  module Helpers
    require 'date'

    FileUtils.mkdir_p("#{Dir.home}/.polycon") unless Dir.exists?("#{Dir.home}/.polycon")
    FileUtils.mkdir_p("#{Dir.home}/.polyconExports") unless Dir.exists?("#{Dir.home}/.polyconExports")
    FileUtils.mkdir_p("#{Dir.home}/.polyconExports/exports_by_date") unless Dir.exists?("#{Dir.home}/.polyconExports/exports_by_date")

    def normalize_html html
      replacements = {
        "&lt;" => "<",
        "&gt;" => ">"
      }
      keys = Regexp.union(replacements.keys)
      return html.gsub(keys, replacements)
    end
  
    def hours
      return [
          "8:00", "8:15", "8:30", "8:45", 
          "9:00", "9:15", "9:30", "9:45", 
          "10:00", "10:15", "10:30", "10:45",
          "11:00", "11:15", "11:30", "11:45",
          "12:00", "12:15", "12:30", "12:45",
          "13:00", "13:15", "13:30", "13:45",
          "14:00", "14:15", "14:30", "14:45",
          "15:00", "15:15", "15:30", "15:45",
          "16:00", "16:15", "16:30", "16:45",
          "17:00", "17:15", "17:30", "17:45", "18:00"]
    end

    def system_dir  
      "#{Dir.home}/.polycon"
    end

    def exports_dir
      "#{Dir.home}/.polyconExports"
    end

    def is_valid_name? name
      #Valida que el nombre solo tenga numeros, letras y espacios
      ex = /^[a-zA-Z\d\s]*$/
      return (ex.match(name) and !name.empty? )
    end

    def beggining_of_week date
      date_parsed = DateTime.strptime(date, '%Y-%m-%d')
      day = date_parsed.strftime("%u")
      monday = date_parsed - (day.to_i - 1)
      return monday
    end

    def professional_exist? name
      return Dir.exist?("#{self.system_dir}/#{name}")
    end

    def appointment_exist? professional, appointment
      return File.exist?("#{self.system_dir}/#{professional}/#{appointment}.paf")
    end
    
  end
end
