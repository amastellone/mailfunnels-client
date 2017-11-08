$(function(){

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();


    /* --- ACCOUNT FORM INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var confirm_email_input = $('#confirm_email_input');

    /* --- CHANGE PASSWORD INPUT FIELDS --- */
    var change_password_input = $('#mf_change_password_input');
    var change_password_confirm_input = $('#mf_confirm_password_input');

    /* --- EMAIL FORM INPUT FIELDS --- */
    var from_name_input = $('#from_name_input');

    /* ---- BUTTONS --- */
    var save_account_info_button = $('#save_account_info_button');
    var save_email_info_button = $('#save_email_info_button');
    var change_password_submit = $('#mf_change_password_submit');
    var upgrade_plan_button = $('.upgrade_plan_button');
    var upgrade_plan_submit_button = $('#upgrade_plan_submit_button');
    var cancel_subscription_button = $('#mf_cancel_subscription_submit');



    // var powered_by_mailfunnels_checkbox = $('#powered_by_mailfunnels_checkbox');
    // var mailfunnel_watermark = $('#mailfunnel_watermark').val();



    /* ---- MODAL ----- */

    var upgrade_plan_modal = $('#upgrade_plan_modal');

    /* ----- SUBSCRIPTION PLAN INFO ------ */
    var plan_id = -1;
    var upgrade_plan_last_four_input = $('#upgrade_plan_last_four_input');


    //Initialize the My Account Page
    init();



    change_password_input.on('keyup', function() {

        //If Password and Confirm Password don't match
        if ($(this).val() !== change_password_confirm_input.val()) {
            change_password_submit.prop('disabled', true);
            return;
        }

        //Check to see if they aren't empty
        if ($(this).val() === '' || change_password_confirm_input.val() === '') {
            change_password_submit.prop('disabled', true);
        } else {
            change_password_submit.prop('disabled', false);
        }

    });

    change_password_confirm_input.on('keyup', function() {

        //If Password and Confirm Password don't match
        if ($(this).val() !== change_password_input.val()) {
            change_password_submit.prop('disabled', true);
            return;
        }

        //Check to see if they aren't empty
        if ($(this).val() === '' || change_password_input.val() === '') {
            change_password_submit.prop('disabled', true);
        } else {
            change_password_submit.prop('disabled', false);
        }
    });

    first_name_input.on('keyup', function() {

        validateAccountInput();

    });

    last_name_input.on('keyup', function() {

        validateAccountInput();

    });

    confirm_email_input.on('keyup', function() {
        validateAccountInput()
    });

    email_input.on('keyup', function() {

        validateAccountInput();

    });

    save_account_info_button.on('click', function(e) {

        var first_name = first_name_input.val();
        var last_name = last_name_input.val();
        var email = email_input.val();
        var confirm_email = confirm_email_input.val();


        if (email !== confirm_email) {
            save_account_info_button.prop('disabled', true);
            return;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_update_account_info',
            dataType: "json",
            data: {
                id: app_id,
                first_name: first_name,
                last_name: last_name,
                email: email,
                confirm_email: confirm_email,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload(true);


            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);

            }

        });

    });

    cancel_subscription_button.on('click', function(e) {

        $.ajax({
            type:'POST',
            url: '/ajax_cancel_subscription',
            dataType: "json",
            data: {

                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload(true);


            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);

            }

        });

    });

    // powered_by_mailfunnels_checkbox.on('change', function () {
    //     if($(this).is(":checked")) {
    //         powered_by_mailfunnels_checkbox.attr('value', true);
    //
    //     } else {
    //         powered_by_mailfunnels_checkbox.attr('value', false);
    //     }
    //
    // });

    // save_account_info_button.on('click', function(e) {
    //
    //
    //     $.ajax({
    //         type: 'POST',
    //         url: '/ajax_test',
    //         dataType: "json",
    //         error: function(e) {
    //             console.log(e);
    //
    //
    //         },
    //         success: function(response) {
    //             console.log(response);
    //         }
    //
    //
    //
    //
    //     });
    //
    //
    // });



    save_email_info_button.on('click', function(e){

        var from_name = from_name_input.val();
        // var checkbox_value = powered_by_mailfunnels_checkbox.val();

        $.ajax({
            type:'POST',
            url: '/ajax_update_email_info',
            dataType: "json",
            data: {
                id: app_id,
                from_name: from_name,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload(true);


            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);

            }

        });
    });

    change_password_submit.on('click', function() {

        //If Password and Confirm Password don't match
        if (change_password_input.val() !== change_password_confirm_input.val()) {
            change_password_submit.prop('disabled', true);
            return;
        }

        //Check to see if they aren't empty
        if (change_password_input.val() === '' || change_password_confirm_input.val() === '') {
            change_password_submit.prop('disabled', true);
            return;
        }


        //AJAX call to update user password
        $.ajax({
            type: 'POST',
            url: '/ajax_change_password',
            data: {
                app_id: app_id,
                password: change_password_input.val(),
                confirm: change_password_confirm_input.val()
            },
            error: function (e) {
                console.log(e);
                window.location.reload();
            },
            success: function (response) {
                console.log(response);
                window.location.reload();
            }
        });

    });


    //On New Node Button Click
    upgrade_plan_button.click(function(event) {
        event.preventDefault();
        upgrade_plan_modal.modal('toggle');
        plan_id = $(this).data('id');

    });

    upgrade_plan_submit_button.on('click', function(e){


        $.ajax({
            type:'POST',
            url: '/ajax_upgrade_plan',
            dataType: "json",
            data: {
                last_four: upgrade_plan_last_four_input.val(),
                subscription_id: plan_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload(true);


            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);

            }

        });
    });


    /**
     * Function that initializes the My Account Page
     *
     */
    function init() {

        //Disable the change Password Button
        change_password_submit.prop('disabled', true);

        //Disable Account Info Button
        save_account_info_button.prop('disabled', true);

        // if (mailfunnel_watermark == 'true'){
        //     powered_by_mailfunnels_checkbox.prop('checked', true);
        //     powered_by_mailfunnels_checkbox.attr('value', true);
        // } else {
        //     powered_by_mailfunnels_checkbox.prop('checked', false);
        //     powered_by_mailfunnels_checkbox.attr('value', false);
        // }

    }

    /**
     * Function that validates email input on account info form
     *
     */
    function validateAccountInput() {

        if (first_name_input.val() === '' || last_name_input.val() === '') {
            save_account_info_button.prop('disabled', true);
            return;
        } else {
            save_account_info_button.prop('disabled', false);
        }

        //If Email and Confirm Email don't match
        if (confirm_email_input.val() !== email_input.val()) {
            save_account_info_button.prop('disabled', true);
            return;
        }

        if (confirm_email_input.val() === '' || email_input.val() === '') {
            save_account_info_button.prop('disabled', true);
        } else {
            save_account_info_button.prop('disabled', false);
        }
    }



});