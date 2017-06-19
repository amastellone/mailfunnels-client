/**
 * jQuery Handler for the FunnelBuilder Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */


var funnel_id;
var app_id;
var csrf_token;
var new_node_label;
var new_node_email_template_select;
var new_node_delay_time_input;
var time_unit_select;
var funnel_builder;
var submit_new_node_button;
var edit_template_button;
var create_new_node_modal;


$(function() {

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    app_id = $('#current_app_id').val();
    funnel_id = $('#current_funnel_id').val();

    /* --- FUNNEL BUILDER COMPONENTS --- */
    funnel_builder = $('#funnel_builder');

    /* --- BUTTONS --- */
    var new_node_button = $('#create_button'); //Create New Job Button
    var delete_selected_button = $('#delete_selected_button'); //Campaign Job Delete Button
    var view_selected_node_button = $('#view_selected_button'); //Campaign Job Edit Button
    submit_new_node_button = $('#new_node_submit_button'); //Add Node Form Submit Button
    var preview_email_button = $('#preview_email_button'); //Preview Email Button

    var edit_node_button = $('#edit_selected_button'); // Edit Node Button
    var save_edit_node_button = $('#edit_node_submit_button'); // Saved Edited Node Button

    var view_template_button = $('#viewButton'); // View Template from node
    edit_template_button = $('#editButton'); // Edit Template from node

    /* --- FORM INPUTS --- */
    new_node_label = $('#new_node_label_input');
    new_node_email_template_select = $('#new_node_email_template_select');
    new_node_delay_time_input = $('#new_node_delay_time_input');
    time_unit_select = $('#time_unit_select');

    /* --- MODALS --- */
    create_new_node_modal = $('#modal_node_create'); //New Job Modal
    var view_node_modal = $('#view_node_modal'); //View Node Info Modal
    var view_template_modal = $('#view_template_modal'); //Preview Email Modal
    var edit_node_modal = $('#modal_node_edit');

    /* --- VIEW INFO MODAL COMPONENTS --- */
    var node_view_name = $('#view_node_name');
    var node_view_email_template_name = $('#view_node_email_template_name');
    var node_view_delay_time = $('#view_node_delay_time');
    var node_view_total_emails = $('#view_node_total_emails');
    var node_view_emails_sent = $('#view_node_emails_sent');
    var node_view_emails_opened = $('#view_node_emails_opened');
    var node_view_emails_clicked = $('#view_node_emails_clicked');
    var node_view_email_settings_template = $('#view_node_email_settings_template');
    var node_view_email_description = $('#view_node_email_description');

    /* --- EDIT NODE MODAL COMPONENTS ---*/
    var edit_node_label = $('#edit_node_label_input');
    var edit_node_email_template_select = $('#edit_node_email_template_select');
    var edit_node_delay_time_input = $('#edit_node_delay_time_input');
    var edit_node_time_unit_select = $('#edit_node_time_unit_select');




    var email_title = $('#printEmailTitle');
    var email_content = $('#printEmailContent');
    var button_text = $('#printButtonText');




    /* --- DYNAMIC VALUES --- */
    var isLoading = false;


    //Setup the initial funnel builder
    init();


    //On New Node Button Click
    new_node_button.click(function(event) {

        create_new_node_modal.modal('toggle');

    });

    // On Create new template value select
    new_node_email_template_select.on('change', function() {

        if(new_node_email_template_select.val() === '0'){
            submit_new_node_button.html('Create A New Template...');
        } else {
            submit_new_node_button.html('Submit');
        }


    });



    delete_selected_button.click(function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');

        if (node_id === '0') {
            alert("Cannot Delete Start Node!");
            return;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_delete_node',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                funnel_builder.flowchart('deleteSelected');
            }
        });

    });


    view_selected_node_button.click(function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');

        $.ajax({
            type:'POST',
            url: '/ajax_load_node_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                node_view_name.html(response.node_name);
                node_view_email_template_name.html(response.email_template_name);
                node_view_delay_time.html(response.node_delay_time);
                node_view_total_emails.html(response.node_total_emails);
                node_view_emails_sent.html(response.node_emails_sent);
                node_view_emails_opened.html(response.node_emails_opened);
                node_view_emails_clicked.html(response.node_emails_clicked);
                node_view_email_settings_template.html(response.email_template_name);
                node_view_email_description.html(response.email_template_description);
                console.log(response);
            }
        });


        view_node_modal.modal('toggle');

    });


    //On Preview Button Click
    preview_email_button.on('click', function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');


        $.ajax({
            type:'POST',
            url: '/ajax_load_email_template_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                email_title.html(response.email_title);
                email_content.html(response.email_content);
                button_text.html(response.button_text);

                if (response.has_button === true) {
                    $('#preview_buttons_div').show();
                } else {
                    $('#preview_buttons_div').hide();
                }

                view_template_modal.modal('toggle');
                console.log(response);
            }
        });

    });




    edit_node_button.on('click', function(){

        edit_node_modal.modal('toggle');

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');


        $.ajax({

            type:'POST',
            url: '/ajax_load_node_edit_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                edit_node_label.val(response.node_name);
                edit_node_email_template_select.val(response.node_email_template_name);
                edit_node_delay_time_input.val(response.node_delay_time);
                edit_node_time_unit_select.val(response.node_delay_unit);
                console.log(response);
            }


        });


    });

    save_edit_node_button.on('click', function(){

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');
        var node_name = edit_node_label.val();
        var email_template_id = edit_node_time_unit_select.val();
        var delay_time = edit_node_delay_time_input.val();
        var time_unit = edit_node_time_unit_select.val();



        $.ajax({

            type:'POST',
            url: '/ajax_save_edit_node',
            dataType: "json",
            data: {
                id: node_id,
                name: node_name,
                email_template_id: email_template_id,
                delay_time: delay_time,
                delay_unit: time_unit,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response){
                edit_node_modal.modal('toggle');
                window.location.reload(true);
                console.log(response);

            }



        });




    });







    /* ---- FUNNEL BUILDER FUNCTIONS --- */
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    function init() {

        // Set loading to true
        isLoading = true;

        // Set the height of the funnel builder panel
        funnel_builder.css('min-height', $(window).height() - 200);

        //Hide the delete and edit selected buttons
        hideButtons();

        //Fake Data For now, switch to live data later
        var data = {};

        $.ajax({
            type:'POST',
            url: '/ajax_load_funnel_json',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                //Start the flowchart plugin
                funnel_builder.flowchart({
                    verticalConnection: true,
                    data: response,
                    onOperatorSelect: function(operatorId) {
                        showButtons(operatorId);
                        return true;
                    },
                    onOperatorUnselect: function() {
                        hideButtons();
                        return true;
                    },
                    onOperatorMoved: function(operatorId) {
                        saveNodeLocation(operatorId);
                        return true;
                    },
                    onLinkCreate: function(linkId, linkData) {
                        saveNewLink(linkId, linkData);
                        return true;
                    }
                });

                // Set loading to false
                isLoading = false;

            }
        });

    }




    /**
     * When a node of the funnel is moved, save the location
     * of the node by calling API call ajax_save_node
     *
     * @param operatorId
     */
    function saveNodeLocation(operatorId) {

        //If Flowchart is loading, return don't create link
        if (isLoading) {
            return;
        }

        if (operatorId === "0") {
            return;
        }

        var operatorData = funnel_builder.flowchart('getOperatorData', operatorId);

        console.log(operatorData);

        $.ajax({
            type:'POST',
            url: '/ajax_save_node',
            dataType: "json",
            data: {
                node_id: operatorId,
                top: operatorData.top,
                left: operatorData.left,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
            }
        });

    }

    /**
     * When a new link is created, save the link to the DB
     * by calling API call ajax_add_link
     *
     *
     * @param linkId
     * @param linkData
     */
    function saveNewLink(linkId, linkData) {

        //If Flowchart is loading, return don't create link
        if (isLoading) {
            return;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_add_link',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
                from_operator_id: linkData.fromOperator,
                to_operator_id: linkData.toOperator,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
            }
        });
    }


    /**
     *
     * When a node is selected show the
     *
     * @param operatorID
     */
    function showButtons(operatorID) {

        if (operatorID === '0') {
            delete_selected_button.hide();
            view_selected_node_button.hide();
            preview_email_button.hide();
            edit_node_button.hide();
            return;
        }

        //Otherwise, show the delete and edit button and change edit button data-node
        delete_selected_button.show();
        view_selected_node_button.show();
        preview_email_button.show();
        edit_node_button.show();

    }

    function hideButtons() {
        delete_selected_button.hide();
        view_selected_node_button.hide();
        preview_email_button.hide();
        edit_node_button.hide()
    }


});

function saveNewNode() {

    var label = new_node_label.val();
    var email_template_id = new_node_email_template_select.val();
    var delay_time = new_node_delay_time_input.val();
    var delay_unit = time_unit_select.val();

    if(email_template_id === '0'){
        email_template_id = null;
    } else{
        email_template_id = email_template_id;
    }


    $.ajax({
        type:'POST',
        url: '/ajax_add_new_node',
        dataType: "json",
        data: {
            app_id: app_id,
            funnel_id: funnel_id,
            email_template_id: email_template_id,
            delay_time: delay_time,
            delay_unit: delay_unit,
            name: label,
            authenticity_token: csrf_token
        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            console.log(response);
            var operatorId = response.id;
            var operatorData = {
                top: 60,
                left: 500,
                properties: {
                    title: label,
                    class: 'flowchart-operator-email-node',
                    inputs: {
                        input_1: {
                            label: ' ',
                        }
                    },
                    outputs: {
                        output_1: {
                            label: ' ',
                        }
                    }
                }
            };
            funnel_builder.flowchart('createOperator', operatorId, operatorData);
        }

    });


    edit_template_button.attr('href', 'edit_email_template/' + email_template_id);
    create_new_node_modal.modal('toggle');
    if(email_template_id == null){
        window.location.replace('funnels/new_email_template.html.erb');
    }
}







