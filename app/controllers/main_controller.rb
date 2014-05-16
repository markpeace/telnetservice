class MainController < ApplicationController

        def command


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
end
