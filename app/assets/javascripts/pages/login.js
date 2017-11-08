$(function() {

    /* ---- Test COMMENT ---- */



    /* --- MESSAGES --- */
    var invalid_credential_message = $('#invalid_login_credentials_message');
    var server_error_message = $('#server_error_message');

    /* --- INPUT FIELDS --- */
    var login_username = $('#mf_login_username_input');
    var login_password = $('#mf_login_password_input');
    var shopify_domain_input = $('#mf_shopify_domain_input');

    /* --- BUTTONS --- */
    var login_submit_button = $('#mf_login_submit_button');
    var shopify_account_submit_button = $('#mf_auth_setup_submit_button');

    //Initialize the login page
    init();


    /**
     * On Login Username Input Change
     *
     * If input field is empty, disable the login button
     */
    login_username.on('keyup', function() {
        if ($(this).val() === '' || login_password.val() === '') {
            login_submit_button.prop('disabled', true);
        } else {
            login_submit_button.prop('disabled', false);
        }
    });


    /**
     * On Login Password Input Change
     *
     * If input field is empty, disable the login button
     */
    login_password.on('keyup', function() {
        if ($(this).val() === '' || login_username.val() === '') {
            login_submit_button.prop('disabled', true);
        } else {
            login_submit_button.prop('disabled', false);
        }
    });


    shopify_domain_input.on('keyup', function() {
        if ($(this).val() === '') {
            shopify_account_submit_button.prop('disabled', true);
        } else {
            shopify_account_submit_button.prop('disabled', false);
        }
    });


    login_submit_button.on('click', function() {

        if (login_username.val() === '' || login_password.val() === '') {
            login_submit_button.prop('disabled', true);
        }

        $.ajax({
            type: 'POST',
            url: '/ajax_mf_user_auth',
            data: {
                mf_auth_username: login_username.val(),
                mf_auth_password: login_password.val()
            },
            error: function(e) {
                console.log(e);
                server_error_message.show();
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    if (response.type === 1) {
                        shopify_account_submit_button.attr('data-id', response.user_id);
                        window.location.href = '#signup';
                    } else {

                        //window.location.href = "https://www.mailfunnels.io/login?shop=" + response.url;
                         window.location.href = "http://localhost:3000/login/?shop=" + response.url;

                    }
                } else {
                    invalid_credential_message.show();
                }
            }

        });

    });

    shopify_account_submit_button.on('click', function() {

        if (shopify_domain_input.val() === '') {
            shopify_account_submit_button.prop('disabled', true);
        }

        var user_id = $(this).data('id');


        $.ajax({
            type: 'POST',
            url: '/ajax_mf_app_create',
            data: {
                user_id: user_id,
                domain: shopify_domain_input.val()
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    //window.location.href = "https://www.mailfunnels.io/login?shop=" + response.url;
                     window.location.href = "http://localhost:3000/login/?shop=" + response.url;
                }
            }
        });

    });


    /**
     * Initializes the Login Page
     *
     */
    function init() {

        window.location.href = '#signin';

        //Disable Shopify Account Submit Button
        shopify_account_submit_button.prop('disabled', true);

        //Hide Error Messages
        invalid_credential_message.hide();
        server_error_message.hide();

    }


});