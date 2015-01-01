class Upload2arduinoController < ApplicationController

        def upload
                @m = "wget "+request.original_url.sub('upload2arduino','sketch.hex')
        end

        def reboot

                Net::SSH.start('bowerfold.dlinkddns.com', 'root', :port=>150, :password => "", :timeout=>120) do |ssh|        
                        ssh.exec "reboot -f &"
                end

                @rebooting = true

                render :upload
        end


        def doupload

                #@m=params[:sketch].read
                #@m=@m.split(" ")

                File.open(Rails.root.join('public', 'sketch.hex'), 'wb') do |file|
                        file.write(params[:sketch].read)                        
                end


                require 'rubygems'
                require 'net/http'
                require 'net/ssh'
                require 'net/sftp'

                Net::SSH.start('bowerfold.dlinkddns.com', 'root', :port=>150, :password => "", :timeout=>120) do |ssh|   
                        #ssh.exec "touch m && rm * &"
                        #@m= && avrdude -q -c arduino -b 57600 -P /dev/ttyUSB0 -p atmega328p -U flash:w:sketch.hex &"
                        ssh.exec!("wget --quiet "+request.original_url.sub('upload2arduino','sketch.hex') + " &")
                        sleep(5)
                        ssh.exec!("avrdude -q -c arduino -b 57600 -P /dev/ttyUSB0 -p atmega328p -U flash:w:sketch.hex && rm * &")
                end


                render :upload
        end

end