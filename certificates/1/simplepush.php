        <?php

        // Put your device token here (without spaces):
        $deviceToken = 'bee87b3ad28ae90e42d24600c19b6169462fd3f683119f2224cf104dd4bcfd36';

        // Put your private key's passphrase here:
        $passphrase = 'letmein';

        // Put your alert message here:
        $message = 'My first push notification!';

        ////////////////////////////////////////////////////////////////////////////////

        $ctx = stream_context_create();
        stream_context_set_option($ctx, 'ssl', 'local_cert', 'production.pem');
        stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
	stream_context_set_option($ctx, 'ssl', 'cafile', 'entrust_2048_ca.cer');

        // Open a connection to the APNS server
        $fp = stream_socket_client(
                'ssl://gateway.push.apple.com:2195', $err,
                $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

        if (!$fp)
                exit("Failed to connect: $err $errstr" . PHP_EOL);

        echo 'Connected to APNS' . PHP_EOL;

        // Create the payload body
        $body['aps'] = array(
                'alert' => $message,
                'sound' => 'default'
        );

        // Encode the payload as JSON
        $payload = json_encode($body);

        // Build the binary notification
        $msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;

        // Send it to the server
        $result = fwrite($fp, $msg, strlen($msg));

        if (!$result)
                echo 'Message not delivered' . PHP_EOL;
        else
                echo 'Message successfully delivered' . PHP_EOL;
        echo $result;

        // Close the connection to the server
        fclose($fp);
