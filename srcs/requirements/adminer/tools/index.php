<?php
function adminer_object() {
    // required to run any plugin
    include_once "./plugins/plugin.php";
    
    // "autoloader"
    foreach (glob("plugins/*.php") as $filename) {
        include_once "./$filename";
    }
    
    $sslConfig = array(
        'key' => '/run/secrets/mariadb_server_key',
        'cert' => '/run/secrets/mariadb_server_cert',
        'ca' => '/run/secrets/ca_cert',
        'verify' => true,
    );
    
    $plugins = array(
        // specify enabled plugins here
        new AdminerLoginSsl($sslConfig),
        //new AdminerDumpXml,
        //new AdminerTinymce,
        //new AdminerFileUpload("data/"),
        //new AdminerSlugify,
        //new AdminerTranslation,
        //new AdminerForeignSystem,
    );
    return new AdminerPlugin($plugins);
}

// include original Adminer or Adminer Editor
include "./adminer.php";
