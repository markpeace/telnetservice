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

                render :json => r

        end
end
