<?php
/**
 * Class for adding a new tab to the application details screen.
 *
 * @package WPCD
 */

if (! defined('ABSPATH')) {
    exit;
}

/**
 * Class for adding a new tab to the application details screen.
 */
class WPCD_WordPress_TABS_APP_PHPMYADMIN extends WPCD_WORDPRESS_TABS
{
    /**
     * WPCD_WORDPRESS_TABS_PHP constructor.
     */
    public function __construct()
    {
        parent::__construct();

        add_filter("wpcd_app_{$this->get_app_name()}_get_tabnames", array( $this, 'get_tab' ), 10, 1);
        add_filter("wpcd_app_{$this->get_app_name()}_get_tabs", array( $this, 'get_tab_fields_phpmyadmin' ), 10, 2);
        add_filter("wpcd_app_{$this->get_app_name()}_tab_action", array( $this, 'tab_action_phpmyadmin' ), 10, 3);

        // add_action( "wpcd_command_{$this->get_app_name()}_completed", array( $this, 'command_completed_sample' ), 10, 2 );

        // Filter to make sure we give the correct file path when merging contents.
        //add_filter( 'wpcd_script_file_name', array( $this, 'wpcd_script_file_name' ), 10, 2 );

        // Filter to handle script file tokens.
        //add_filter( 'wpcd_wpapp_replace_script_tokens', array( $this, 'wpcd_wpapp_replace_script_tokens' ), 10, 7 );
    }


    /**
     * Populates the tab name.
     *
     * @param array $tabs The default value.
     *
     * @return array    $tabs The default value.
     */
    public function get_tab($tabs)
    {
        $tabs['phpMyAdminAutoLogin'] = array(
            'label' => __('phpMyAdminAutoLogin', 'wpcd'),
        );
        return $tabs;
    }


    /**
     * Gets the fields to be shown in the phpMyAdminAutoLogin tab.
     *
     * Filter hook: wpcd_app_{$this->get_app_name()}_get_tabs
     *
     * @param array $fields list of existing fields.
     * @param int   $id post id of app being worked with.
     *
     * @return array Array of actions, complying with the structure necessary by metabox.io fields.
     */
    public function get_tab_fields_phpmyadmin(array $fields, $id)
    {
        return $this->get_fields_for_tab($fields, $id, 'phpMyAdminAutoLogin');
    }

    /**
     * Called when an action needs to be performed on the tab.
     *
     * @param mixed  $result The default value of the result.
     * @param string $action The action to be performed.
     * @param int    $id The post ID of the app.
     *
     * @return mixed    $result The default value of the result.
     */
    public function tab_action_phpmyadmin($result, $action, $id)
    {
        switch ($action) {
            case 'phpmyadmin-action-autologin':
                $result = $this->phpmyadmin_action_autologin($id, $action);
                break;
            // case 'sample-action-b':
            // 	$result = $this->sample_action_b( $id, $action );
            // 	break;
            // case 'sample-action-c':
            // 	$result = $this->sample_action_c( $id, $action );
            // 	break;
        }

        return $result;
    }

    /**
     * Gets the actions to be shown in the Sample tab.
     *
     * @param int $id The post ID of the server.
     * @return array Array of actions with key as the action slug and value complying with the structure necessary by metabox.io fields.
     */
    public function get_actions($id)
    {
        return $this->get_server_fields_phpmyadmin($id);
    }

    /**
     * Gets the fields for the services to be shown in the Sample tab in the server details screen.
     *
     * @param int $id the post id of the app cpt record.
     *
     * @return array Array of actions with key as the action slug and value complying with the structure necessary by metabox.io fields.
     */
    private function get_server_fields_phpmyadmin($id)
    {

        // Set up metabox items.
        $actions = array();

        // Heading.
        $sample_desc  = __('This will autologin you to phpMyAdmin!', 'wpcd');
        $sample_desc .= '<br />';


        $actions['phpmyadmin-add-on-heading'] = array(
            'label'          => __('phpMyAdmin', 'wpcd'),
            'type'           => 'custom_html',
            'class' => 'button',
            'raw_attributes' => array(
                // 'desc' => $sample_desc,
                'std'  => $this->phpmyadmin_action_autologin($id, 'phpmyadmin-action-autologin'),
                // 'columns' => 12,

            ),
        );

        // $actions['phpmyadmin-action-autologin'] = array(
        //     'label'          => __('Autologin to phpMyAdmin', 'wpcd'),
        //     'attributes' => array(
        //         'std'                 => $this->phpmyadmin_action_autologin($id, 'phpmyadmin-action-autologin'),
        //         'desc'                => __('This will autologin you to phpMyAdmin!', 'wpcd'),
        //         // the _action that will be called in ajax.
        //         'data-wpcd-action'              => 'phpmyadmin-action-autologin',
        //         // the id.
        //         'data-wpcd-id'                  => $id,
        //         // fields that contribute data for this action.
        //         //'data-wpcd-fields'    => wp_json_encode( array( '#wpcd_app_action_sample-action-field-01' ) ),
        //         // make sure we give the user a confirmation prompt.
        //         //'confirmation_prompt' => __( 'Are you sure you would like to update all plugins?', 'wpcd' ),
        //     ),
        //     'type'           => 'button',
        //     'class'      => 'wpcd_app_action',
        //     'save_field' => false,
        // );


        return $actions;
    }

    private function phpmyadmin_action_autologin($id, $action)
    {

        // Get the instance details.
        $instance = $this->get_app_instance_details($id);

        if (is_wp_error($instance)) {
            /* translators: %s is replaced with the name of the action being executed */
            return new \WP_Error(sprintf(__('Unable to execute this request because we cannot get the instance details for action %s', 'wpcd')));
        }

        // Get the domain we're working on.
        $domain = $this->get_domain_name($id);

        if ('on' == get_post_meta($id, 'wpapp_ssl_status', true)) {
            $phpmyadmin_url = 'https://' . $this->get_domain_name($id) . '/' . 'phpMyAdmin';
        } else {
            $phpmyadmin_url = 'http://' . $this->get_domain_name($id) . '/' . 'phpMyAdmin';
        }

        // use custom html to show a launch link.
        $phpmyadmin_user_id  = get_post_meta($id, 'wpapp_phpmyadmin_user_id', true);
        $phpmyadmin_password = $this::decrypt(get_post_meta($id, 'wpapp_phpmyadmin_user_password', true));

        // Remove any "user:" and "Password:" phrases that might be embedded inside the user id and password strings.
        $phpmyadmin_user_id  = str_replace('User: ', '', $phpmyadmin_user_id);
        $phpmyadmin_password = str_replace('Password: ', '', $phpmyadmin_password);
        $phpmyadmin_user_id  = trim($phpmyadmin_user_id);
        $phpmyadmin_password = trim($phpmyadmin_password);
        
        // worst versions shows user/pass params in clickable hyperlink
        $html_get_working = <<<EOT
        <form name="myform" method="get" action="$phpmyadmin_url/phpmyadminsignin.php?username=$phpmyadmin_user_id&password=$phpmyadmin_password" target="_blank">
		</form>
		<a href="$phpmyadmin_url/phpmyadminsignin.php?username=$phpmyadmin_user_id&password=$phpmyadmin_password" onClick="document.forms['myform'].submit(); return false;">Autologin to phpMyAdmin</a>

EOT;
        // Button version which hides links and is only clickable tolerable but not ideal
        $html_get_button = <<<EOT
		<form>
		<button formaction="$phpmyadmin_url/phpmyadminsignin.php?username=$phpmyadmin_user_id&password=$phpmyadmin_password">Autologin to phpMyAdmin</button>
		</form>
EOT;

        // testing with post again fails tried all sorts of variations this works locally to the same link
        $html_post = <<<EOT
		<!DOCTYPE html>
		<html lang="en">
		<head>
			<meta charset="UTF-8">
			<title>phpMyAdmin Login</title>
			<script>
				function loginForm() {
					document.myform.submit();
					document.myform.action = "$phpmyadmin_url/signon.php";
				}
			</script>
		</head>
		<body onload="loginForm()">
		<form action="$phpmyadmin_url/phpmyadminsignin.php" name="myform" method="post" target="_blank">
			<input type="hidden" type="text" name="username" value="$phpmyadmin_user_id">
			<input type="hidden" type="password" name="password" value="$phpmyadmin_password">
			<input type="submit" value="Autologin to phpMyAdmin in a new window">
		</form>
		</body>
		</html>
EOT;
        // return $html_get_button;
        return $html_post;

        // the below works but exposes the full get link and
        // $url = "$phpmyadmin_url/phpmyadminsignin.php?username=$phpmyadmin_user_id&password=$phpmyadmin_password";
        // $name = 'Autologin to phpMyAdmin in a new window';
        // return sprintf( '<a href="%s" target="_blank">', $url ) . __( 'Launch PHPMyAdmin', 'wpcd' ) . '</a>';
    }
}

new WPCD_WordPress_TABS_APP_PHPMYADMIN();
