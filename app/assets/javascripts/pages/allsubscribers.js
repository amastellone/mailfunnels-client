/* --- APP VALUES DECLARATIONS --- */
var csrf_token;
var app_id;
var email_list_id;

$(function() {


    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();
    email_list_id = $('#current_email_list_id').val();


    /* --- MODALS --- */
    var new_subscriber_modal = $('#new_subscriber_modal');
    var new_batch_email_modal = $('#new_batch_email_modal');
    var subscriber_info_modal = $('#subscriber_info_modal');

    /* --- INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var template_list_select = $('#template_list_select');
    var email_list_name = $('#email_list_name');


    /* --- BUTTONS --- */
    var new_subscriber_submit_button = $('#new_subscriber_submit_button');
    var batch_email_send_button = $('#batch_email_send_button');
    var view_subscriber_info_button = $('#view_subscriber_info_button');


    new_subscriber_submit_button.on('click', function() {

        var first_name = first_name_input.val();
        var last_name = last_name_input.val();
        var email = email_input.val();

        console.log(first_name + " " + last_name + " " + email);

        $.ajax({
            type:'POST',
            url: '/ajax_create_subscriber',
            dataType: "json",
            data: {
                app_id: app_id,
                first_name: first_name,
                last_name: last_name,
                email: email,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_subscriber_modal.modal('toggle');
            }
        });
        
    });

    batch_email_send_button.on('click', function(){

        var template = template_list_select.val();


        $.ajax({
            type:'POST',
            url:'/ajax_create_batch_email',
            dataType: "json",
            data: {
                app_id: app_id,
                email_template_id: template,
                email_list_id: email_list_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
            }
        });

        new_batch_email_modal.modal('toggle');

    });


});

/**
 * DeleteSubscriber Function
 * -------------------------
 * Calls API call to delete a subscriber from DB
 * and add them to the unsubscriber list
 *
 * @param id
 */
function deleteSubscriber(id) {

    $.ajax({
        type: 'POST',
        url: '/ajax_delete_subscriber',
        dataType: "json",
        data: {
            app_id: app_id,
            subscriber_id: id,
            authenticity_token: csrf_token
        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            console.log(response);
            window.location.reload(true);

        }
    });

}


function viewSubscriberInfo(id) {


    /* --- View Info Fields --- */
    var subscriber_view_id = $('#view_subscriber_id');
    var subscriber_view_first_name = $('#view_subscriber_first_name');
    var subscriber_view_last_name = $('#view_subscriber_last_name');
    var subscriber_view_email = $('#view_subscriber_email');
    var subscriber_view_revenue = $('#view_subscriber_revenue');

    $.ajax({
        type:'POST',
        url:'/ajax_load_subscriber_info',
        dataType: "json",
        data: {
            app_id: app_id,
            subscriber_id: id,
            authenticity_token: csrf_token,

        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            $('#delete_subscriber_button').attr('onclick', 'deleteSubscriber(' + response.id + ')');
            subscriber_view_id.html(response.id);
            subscriber_view_first_name.html(response.first_name);
            subscriber_view_last_name.html(response.last_name);
            subscriber_view_email.html(response.email);
            subscriber_view_revenue.html("$" + response.revenue);
            console.log(response);

            var obj = JSON.parse(response.emails);

            for(var i = 0; i < response.total_emails; i++) {
                var html = "<tr>";
                html = html + "<td>" + obj[i].name + "</td>";

                if( obj[i].clicked === 1 ){
                    html = html + "<td>" + "Yes" + "</td>";
                } else {
                    html = html + "<td>" + "No" + "</td>";
                }

                if( obj[i].opened === 1 ){
                    html = html + "<td>" + "Yes" + "</td>";
                } else {
                    html = html + "<td>" + "No" + "</td>";
                }

                html = html + "</tr>";
                $('#sub_table_body').append(html);
            }
        }

    });


}
