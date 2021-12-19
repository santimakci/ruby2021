module Polycon  
  class Professional
      extend Helpers
      require 'fileutils'

      def self.professional_create name
        Dir.mkdir "#{system_dir}/#{name}"  
        puts "Professional created correctly"
      end

      def self.create name
        if is_valid_name? name 
          if !professional_exist? name 
            self.professional_create name
          else
            puts "Professional already exists"
          end
        else
          puts "Professional name is invalid"
        end
      end

      def self.list_professionals
        Dir.foreach(system_dir) do |dir|
          if File.directory?("#{system_dir}/#{dir}") && dir != "." && dir != ".." && dir != "exports_by_date"
            puts dir
          end
        end
      end

      def self.rename_professional old_name, new_name
        if professional_exist? old_name and is_valid_name? new_name and !professional_exist? new_name
          File.rename("#{system_dir}/#{old_name}", "#{system_dir}/#{new_name}")
          return puts "Professional name was modified to: #{new_name}"
        else
          puts "Professional #{old_name} doesn't exists or new name is invalid"
        end
      end


      def self.delete_proffesional name
        if !professional_exist? name
          return puts "Professional doesn't exists"  
        end
        if !Dir.empty? "#{system_dir}/#{name}"
          return puts "Professional has appointments"
        end
        begin
          FileUtils.rm_r "#{system_dir}/#{name}" 
          return puts "Professional has been deleted"
        rescue
          return puts "There was an error, the professional couldn't be deleted"
        end
      end

      def self.get_array_professionals
        professionals = []
        Dir.foreach("#{system_dir}/") do |file|
          if file != "." && file != ".." && file != "exports_by_date"
            professionals.push(file)
          end
        end
        return professionals
      end
  end
end