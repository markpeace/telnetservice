class Upload2arduinoController < ApplicationController

        def upload
                @m=""
        end

        def doupload
                @m=uploaded_io = params[:sketch]

                File.open(Rails.root.join('public', 'sketch.hex'), 'wb') do |file|
                        file.write(params[:sketch].read)
                end

                render :upload
        end

end
