module Polycon
  module Templates  
    def html_in_date data, headers, *options
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
  end 
end