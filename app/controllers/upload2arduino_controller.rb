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
                        ssh.exec "touch mark.test"
                        #ssh.exec!("wget http://ordeal-dromic.codio.io:3000/sketch.hex")
                        ssh.exec!("wget http://mptoolbox.herokuapp.com/sketch.hex")
                end
                
                render :upload

        end
end