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
                        ssh.exec "cd /"
                        @m=ssh.exec!("ls")
                end
                
                render :upload

        end
end