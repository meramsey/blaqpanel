<?php
// For Post type signon auth
define("PMA_SIGNON_INDEX", 3);
try {
    define('PMA_SIGNON_SESSIONNAME', 'SignonSession3');
    define('PMA_DISABLE_SSL_PEER_VALIDATION', true);

    if (isset($_GET['logout'])) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 86400, $params["path"], $params["domain"], $params["secure"], $params["httponly"]);
        session_destroy();
        header('Location: /phpMyAdmin');
        return;
    } elseif (isset($_POST['password'])) {
        session_name(PMA_SIGNON_SESSIONNAME);
        @session_start();

        $username = $_POST['username'];
        $password = $_POST['password'];

        $_SESSION['PMA_single_signon_user'] = $username;
        $_SESSION['PMA_single_signon_password'] = $password;
        $_SESSION['PMA_single_signon_host'] = 'localhost';


        @session_write_close();

        header('Location: /phpMyAdmin/index.php?server=' . PMA_SIGNON_INDEX);
    }
} catch (Exception $e) {
    echo 'Caught exception: ',  $e->getMessage(), "\n";
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 86400, $params["path"], $params["domain"], $params["secure"], $params["httponly"]);
    session_destroy();
    header('Location: /phpMyAdmin');
    return;
}
