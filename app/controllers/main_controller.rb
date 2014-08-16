class MainController < ApplicationController

        def telnet 


                require 'net/telnet'

                r=""

                host = Net::Telnet::new(
                        "Host" => params[:server],
                        "Port" => params[:port],
                        "Prompt" => ">"
                        )

                host.puts(params[:command])

                host.waitfor(/\n/) do |txt|
                        r=r+txt
                end                       

                host.close

                headers['Access-Control-Allow-Origin'] = '*'
                headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
                headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
                headers['Access-Control-Max-Age'] = "1728000"                

                render :json => r

        end

        def scrape
                require 'open-uri'

                r = ""

                open(params[:protocol] + "://" +params[:address]) {|f|
                        f.each_line {|line| r=r+line }
                        }

                r=URI.encode(r)

                headers['Access-Control-Allow-Origin'] = '*'
                headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
                headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
                headers['Access-Control-Max-Age'] = "1728000"        

                render :json => { result: r}                
        end       

        def pushnotify

                APNS.host = 'gateway.push.apple.com' 
                # gateway.sandbox.push.apple.com is default and only for development
                # gateway.push.apple.com is only for production

                APNS.port = 2195 
                # this is also the default. Shouldn't ever have to set this, but just in case Apple goes crazy, you can.

                APNS.pem  = 'certificates/1/production.pem'
                # this is the file you just created

                APNS.pass = 'letmein'
                # Just in case your pem need a password

                device_token = 'bee87b3ad28ae90e42d24600c19b6169462fd3f683119f2224cf104dd4bcfd36'
                APNS.send_notification(device_token, 'Hello iPhone!' )
                APNS.send_notification(device_token, :alert => 'Hello iPhone!', :badge => 1, :sound => 'default')

                r="Mark"

                headers['Access-Control-Allow-Origin'] = '*'
                headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
                headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
                headers['Access-Control-Max-Age'] = "1728000"        

                render :json => { result: r}                
        end       

end
