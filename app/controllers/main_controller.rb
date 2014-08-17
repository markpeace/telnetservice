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

                data=JSON.parse(params[:data])                                  

                APNS.host = 'gateway.push.apple.com' 
                APNS.port = 2195 
                APNS.pem  = "certificates/" + data['applicationIndex']+"/production.pem"
                APNS.pass = ENV['PUSH_PASSWORD']

                device_token = 'bee87b3ad28ae90e42d24600c19b6169462fd3f683119f2224cf104dd4bcfd36'

                data['badge'] ||= 1
                data['sound'] ||= 'default'	
                data['payload'] ||= {}	

                messages=[]                
                data['tokens'].each do |token|
                        messages.push(APNS::Notification.new(token, :alert => data['alert'], :badge => data['badge'], :sound => data['sound'], :other => data['payload']))
                end                             

                APNS.send_notifications(messages)                

                headers['Access-Control-Allow-Origin'] = '*'
                headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
                headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
                headers['Access-Control-Max-Age'] = "1728000"        

                respond_to do |format|
                        format.html { head :ok}
                        format.xml  { head :ok }
                        format.json { head :ok }
                end                
        end       

end
