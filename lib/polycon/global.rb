module Global
  #Estas lineas crean el directorio .my_rns y el cuaderno global si es que no existen
  FileUtils.mkdir_p("#{Dir.home}/.polycon") unless Dir.exists?("#{Dir.home}/.polycon")
  
  def system_dir  
    "#{Dir.home}/.polycon"
  end
  
  def is_valid_name? name
    #Valida que el nombre solo tenga numeros, letras y espacios
    ex = /^[a-zA-Z\d\s]*$/
    return ex.match(name)
  end

  def professional_exist? name
    return Dir.exist?("#{self.system_dir}/#{name}")
  end

  def appointment_exist? professional, appointment
    return File.exist?("#{self.system_dir}/#{professional}/#{appointment}.paf")
  end


end
