Rails.application.routes.draw do
        get 'wake' => "wake#index"

        get 'main/command'

        get 'telnet/:server/:port/:command' => "main#telnet", :constraints => { :server => /[^\/]+/ }

        get 'scrape/:protocol/:address/' => "main#scrape", :constraints => {:address => /.*/}

        match "/pushnotify" => "main#pushnotify", :via => [:post, :get]

        get 'upload2arduino' => "upload2arduino#upload"      
        get 'rebootarduino' => "upload2arduino#reboot" 
        post 'upload2arduino' => "upload2arduino#doupload"    
end
