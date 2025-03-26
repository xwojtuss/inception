<?php // adminer-plugins.php
return array(
    new AdminerLoginSsl([
        'key' => '/run/secrets/mariadb_server_key',
        'cert' => '/run/secrets/mariadb_server_cert',
        'ca' => '/run/secrets/ca_cert',
        'verify' => true
    ])
);
