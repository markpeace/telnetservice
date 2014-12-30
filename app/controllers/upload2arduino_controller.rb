class Upload2arduinoController < ApplicationController

        def upload
                @m=""
        end

        def doupload
                @m=uploaded_io = params[:sketch]

                File.open(Rails.root.join('public', 'sketch.hex'), 'wb') do |file|
                        file.write(params[:sketch].read)
                end


                require 'rubygems'
                require 'net/http'
                require 'net/ssh'

                Net::SSH.start('bowerfold.dlinkddns.com', 'root', :port=>150, :password => "mmmbeer00") do |ssh|
                        #@m=ssh.exec!("wget http://www.google.com")
                        @m=ssh.exec!("wget http://ordeal-dromic.codio.io:8080/sketch.hex") 
                        #ssh.exec "avrdude -c arduino -b 57600 -P /dev/ttyUSB0 -p atmega328p -vv -U flash:w:sketch.hex"
                end
                
                render :upload

        end
end