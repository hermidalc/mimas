/*
# mimas.js
# MIMAS Master JavaScript File
#
#######################################################
# Copyright 2003-2005 Leandro C. Hermida
# This code is part of MIMAS and is distributed under
# GNU Public License Version 2.
#######################################################
# $Id$
*/

<!-- Hide script
//<![CDATA[


// -------------------------------------------------------------------- COMMON FUNCTIONS -------------------------------------------------------------------- //


// UTILITY FUNCTION TO CHECK FOR A BLANK FIELD
function isblank(field) {
    return field.search(/^\s*$/) != -1 ? true : false;
}


// UTILITY FUNCTION TO CHECK IF FIELD IS IN PROPER DATE FORMAT "DD-MM-YYYY"
function isdate(field) {
    return field.search(/^\d{2}-\d{2}-\d{4}$/) != -1 ? true : false;
}


// UTILITY FUNCTION TO CHECK IF FIELD IS AN INTEGER
function isinteger(field) {
    return field.search(/^-?\d+$/) != -1 ? true : false;
}


// UTILITY FUNCTION TO CHECK IF A FIELD IS NUMERIC AND WITHIN MIN AND MAX SPECIFIED
// SET .min and .max PROPERTIES OF FIELD BEFORE CALLING FUNCTION IF YOU WANT TO CHECK NUMERICAL LIMITS
function checknumber(field) {
    var v;
    
    if (field.value !== undefined) {
        v = parseFloat(field.value);
        if (v != field.value) return false;
    }
    else {
        v = parseFloat(field);
	if (v != field) return false;
    }
    
    if (isNaN(v) || 
       ((field.min != null) && (v < field.min)) || 
       ((field.max != null) && (v > field.max))) return false;
    
    return true;
}


// UTILITY FUNCTION TO CLEAN UP WHITESPACE
function clean_whitespace(field) {
    field = field.replace(/^\s+/, '');
    field = field.replace(/\s+$/, '');
    field = field.replace(/\s+/g, ' ');
    return field;
}


// UTILITY FUNCTION TO CLEAN FREE TEXT FIELDS
function clean_freetext(field) {
    field = field.replace(/^\s+/, '');
    field = field.replace(/\s+$/, '');
    return field;
}


// ALPHABETIC CASE INSENSITIVE SORT FUNCTION
function ignoringcase(a, b) {
    var x = a.text  !== undefined ? a.text.toLowerCase()  :
            a.value !== undefined ? a.value.toLowerCase() : a;
    var y = b.text  !== undefined ? b.text.toLowerCase()  :
            b.value !== undefined ? b.value.toLowerCase() : b;
    
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}


// UTILITY FUNCTION TO SORT SELECT ELEMENT OPTIONS BY TEXT FIELD -- PUTS "Other..." AFTER LIBRARY OPTIONS AND IF 
// OPTGROUP EXISTS SORTS THESE OPTIONS SEPARATELY AND PUTS AT END
function sortoptions(selectelement, targetwindow) {
    var lib_options  = new Array();
    var lib_group_options = new Array();
    var user_options = new Array();
    var other_option;
    var none_na_option;
    var optgrp;
    
    for (var i = 0; i < selectelement.options.length; i++) {
        // "none/not applicable" OPTION
	if (selectelement.options[i].id && selectelement.options[i].id == 'option_none_' + selectelement.name) {
	    none_na_option  = selectelement.options[i];
	}
	// "Other..." OPTION
	else if (selectelement.options[i].id && selectelement.options[i].id == 'option_other_' + selectelement.name) {
	    other_option = selectelement.options[i];
	}
	else if ((optgrp = selectelement.options[i].getAttribute("_mimas_optgroup"))
            && document.getElementById(optgrp)
            && document.getElementById(optgrp).parentNode == selectelement
) {
        if (typeof lib_group_options[optgrp] == 'undefined') {
            lib_group_options[optgrp] = new Array();
        }
        lib_group_options[optgrp].push(selectelement.options[i]);
    }
	else {
	    // OPTION IS IN USER OPTGROUP
	    if (selectelement.options[i].parentNode.id && selectelement.options[i].parentNode.id == 'optgroup_user_' + selectelement.name) {
	        user_options.push(selectelement.options[i]);
	    }
	    // OPTION IS IN MAIN MIMAS LIBRARY LIST
	    else {
	        lib_options.push(selectelement.options[i]);
	    }
	}
    }

    for (var grp in lib_group_options) {
        lib_group_options[grp].sort(ignoringcase);
        for (var i = 0; i < lib_group_options[grp].length; i++) {
            var optgrp = document.getElementById(grp);
            document.getElementById(grp).appendChild(lib_group_options[grp][i], user_optgroup);
        }
    }
    
    lib_options.sort(ignoringcase);
    user_options.sort(ignoringcase);
    
    var user_optgroup = targetwindow.document.getElementById('optgroup_user_' + selectelement.name);
    
    for (var i = 0; i < lib_options.length; i++) {
	lib_options[i].innerHTML = lib_options[i].text; // internet explorer fix
	selectelement.insertBefore(lib_options[i], user_optgroup);
    }
    
    if (none_na_option) {
        selectelement.insertBefore(none_na_option, user_optgroup);
    }
    
    if (other_option) {
        selectelement.insertBefore(other_option, user_optgroup);
    }
    
    for (var i = 0; i < user_options.length; i++) {
        user_options[i].innerHTML = user_options[i].text; // internet explorer fix
	user_optgroup.appendChild(user_options[i]);
    }
    
    // deselect any selected elements
    selectelement.selectedIndex = -1;
}


// CREATES USER-DEFINED OPTGROUP
function createuseroptgroup(selectelement, targetwindow) {
    
    var optgroup       = targetwindow.document.createElement('optgroup');
    optgroup.id        = 'optgroup_user_' + selectelement.name;
    optgroup.label     = 'User-defined:';
    optgroup.className = 'itbld';
    selectelement.appendChild(optgroup);
    
    return optgroup;
}


// CREATES CORRESPONDING HIDDEN ELEMENT FOR USER-DEFINED SELECT ELEMENT OPTION
function createuserhidden(selectelement, othervalue, targetwindow) {
    var frm = selectelement.form;
    
    var new_hidden   = targetwindow.document.createElement('input');
    new_hidden.type  = 'hidden';
    new_hidden.name  = 'other_' + selectelement.name;
    new_hidden.value = othervalue;
    frm.appendChild(new_hidden);
}


// CREATES USER-DEFINED SELECT ELEMENT OPTION FROM "Other..."
function createuseroption(selectelement, othervalue, selectfocus, targetwindow) {
    var frm = selectelement.form;
    
    var user_option             = targetwindow.document.createElement('option');
    user_option.text            = othervalue;
    user_option.value           = othervalue;
    user_option.defaultSelected = false;
    user_option.selected        = selectfocus;
    user_option.innerHTML       = user_option.text; // internet explorer fix
    user_option.className       = 'italic';
    
    var user_optgroup = targetwindow.document.getElementById('optgroup_user_' + selectelement.name);
    if (user_optgroup) {
        user_optgroup.appendChild(user_option);
    }
    else {
        user_optgroup = createuseroptgroup(selectelement, targetwindow);
        user_optgroup.appendChild(user_option);
    }
}


function getothervalue(select) {
    var warning = ''; // 'Understand that you are PERMANENTLY adding the value/unit to MIMAS!\n';

    var previous = select.getAttribute("_previous_other_value") || "";
    
    while (true) {
        var othervalue = prompt(warning + 'Please enter a new user-defined value:', previous);
        if (othervalue && !isblank(othervalue) && (othervalue.search(/^\s*o\s*t\s*h\s*e\s*r\s*$/i) == -1)) {
            othervalue = clean_whitespace(othervalue);
	    
	    // do not allow numeric entry
            if (checknumber(othervalue)) {
                alert('Field cannot be numeric!');
            }
            // do not allow "none", "not applicable", or "none/not applicable" entry
            else if (othervalue.search(/^(none|(none|not) applicable|N\/A|none\/not applicable)$/i) != -1) {
                alert('Field cannot be none, not applicable, or N/A.  This option should already be provided at the end of the list if it is allowed.');
            }
	    else {
		select.setAttribute("_previous_other_value", othervalue);
	        return othervalue;
	    }
        }
	else {
	    return;
	}
    }
}


// COMMON FUNCTION TO CHECK SELECT-ONE ELEMENT OPTIONS IF USER SELECTS "OTHER..." TO CREATE A NEW USER-DEFINED OPTION
function checkselectone(selectelement) {
    var frm          = selectelement.form;
    var other_option = document.getElementById('option_other_' + selectelement.name);
    
    // "Other..." option selected
    if (other_option && other_option.selected == true) {
        var othervalue = getothervalue(selectelement);
	if (othervalue) {
	    var duplicate_index = -1;
            for (var i = selectelement.options.length - 1; i >= 0; i--) {
	        // check select element for duplicates
	        if (selectelement.options[i].text.toLowerCase() == othervalue.toLowerCase()) {
                    duplicate_index = i;
	            break;
                }
	        // clear any previous user-defined values for select-one elements
	        /*
	        else if (i > other_option.index) {
                    selectelement.options[i] = null;
                }
	        */
            }
	    
            if (duplicate_index < 0) {
	        createuseroption(selectelement, othervalue, true, window);
            }
            else {
                selectelement.options[duplicate_index].selected = true;
            }
	}
	// reset select-one element
        else {
            selectelement.selectedIndex = 0;
        }
    }
}

function getQuintessence(selectelement) {
    var frm          = selectelement.form;
    var q_area       = document.getElementById('quintessence');
    q_area.value = quintessence[selectelement.value];
}


function checkfieldtype(form) {
    for (var i in form.elements) {
        var el = form.elements[i];
        if (el.name.indexOf('form_type') == 0) {
            if (el.value.length == 0) {
            alert("You must select an upload form type");
            return false;
            }
        }
    }
    return false;
}

function moveselectmultidetail(sourceselect, targetselect, source_option) {
    var source_user_optgroup = document.getElementById('optgroup_user_' + sourceselect.name);
    var target_user_optgroup = document.getElementById('optgroup_user_' + targetselect.name);
    
    var target_option;
    if (source_user_optgroup && source_option.parentNode === source_user_optgroup) {
        if (target_user_optgroup) {
            target_option = target_user_optgroup.appendChild(source_option);
        }
        else {
            target_user_optgroup = createuseroptgroup(targetselect, window);
            target_option = target_user_optgroup.appendChild(source_option);
        }
    }
    else {
        target_option = targetselect.insertBefore(source_option, target_user_optgroup);
    }
    
    target_option.selected = false;
}


// COMMON FUNCTION TO ADD/REMOVE SELECT MULTIPLE ELEMENT OPTIONS 

function checkselectmulti(frm, source_element_name, target_element_name, popupurl) {
    var sourceselect = frm.elements[source_element_name];
    var targetselect = frm.elements[target_element_name];
    
    var source_user_optgroup = document.getElementById('optgroup_user_' + sourceselect.name);
    var target_user_optgroup = document.getElementById('optgroup_user_' + targetselect.name);
    
    var none_na_option = document.getElementById('option_none_' + sourceselect.name);
    
    for (var i = sourceselect.options.length - 1; i >= 0; i--) {
        if (sourceselect.options[i].selected == true) {
	    var target_duplicate = false;
	    for (var j = 0; j < targetselect.options.length; j++) {
	        if (targetselect.options[j].text.toLowerCase() == sourceselect.options[i].text.toLowerCase()) {
	            target_duplicate = true;
		    break;
	        }
	    }
	    
	    // "Other..." option selected
	    if (sourceselect.options[i].id == 'option_other_' + sourceselect.name) {
	        // special popup windows (i.e. experimental factors menu)
		if (popupurl) {
		    // global "popup_win" so we can close it easily in body onunload
		    // for "new factor", if you change the width and height here change also in togglefactorunits()
		    popup_win = window.open(popupurl, 'popup', 'width=350,height=165,status=no,resizable=no,scrollbars=no,toolbar=no');
		    popup_win.focus();
		}
		// default
		else {
		    var othervalue = getothervalue(targetselect);
		    if (othervalue) {
		        var target_duplicate_index = -1;
                        for (var j = 0; j < targetselect.options.length; j++) {
	                    // check target select element for duplicates
	                    if (targetselect.options[j].text.toLowerCase() == othervalue.toLowerCase()) {
                                target_duplicate_index = j;
	                        break;
                            }
                        }
			
			if (target_duplicate_index < 0) {
			    var source_duplicate_index = -1;
			    for (var j = 0; j < sourceselect.options.length; j++) {
	                        // check source select element for duplicates
	                        if (sourceselect.options[j].text.toLowerCase() == othervalue.toLowerCase()) {
                                    source_duplicate_index = j;
	                            break;
                                }
                            }
			    
			    if (source_duplicate_index < 0) {
			        createuseroption(targetselect, othervalue, false, window);
				if (none_na_option && none_na_option.parentNode === targetselect) {
				    moveselectmultidetail(targetselect, sourceselect, none_na_option);
				}
			    }
			    else {
			        moveselectmultidetail(sourceselect, targetselect, sourceselect.options[source_duplicate_index]);
				// since I am moving an option out of the sourceselect list before myself
				if (i >= source_duplicate_index) i--;
			    }
			}
		    }
		    // reset target select-multiple element
		    else {
		        targetselect.selectedIndex = -1;
		    }
		    
		    sourceselect.options[i].selected = false;
		}
	    }
	    else if (target_duplicate) {
	        sourceselect.options[i] = null;
	    }
	    else {
		if (none_na_option) {
		    if (none_na_option === sourceselect.options[i]) {
		        for (var j = targetselect.options.length - 1; j >= 0; j--) {
			    moveselectmultidetail(targetselect, sourceselect, targetselect.options[j]);
			}
		    }
		    else if (none_na_option.parentNode === targetselect) {
		        // I could be at a user-defined option and adding the none_na_option will put it in the list before myself
			var source_user_defined = false;
			if (source_user_optgroup && sourceselect.options[i].parentNode === source_user_optgroup) source_user_defined = true;
			moveselectmultidetail(targetselect, sourceselect, none_na_option);
			if (source_user_defined) i++;
		    }
		}
		
		moveselectmultidetail(sourceselect, targetselect, sourceselect.options[i]);
	    }
	}
    }
    
    // remove "User-defined:" optgroups if there is nothing in them
    if (source_user_optgroup && source_user_optgroup.childNodes.length == 0) {
        sourceselect.removeChild(source_user_optgroup);
    }
    if (target_user_optgroup && target_user_optgroup.childNodes.length == 0) {
        targetselect.removeChild(target_user_optgroup);
    }
    
    sortoptions(sourceselect, window);
    sortoptions(targetselect, window);
}

//variant with multiple possible source elements
function checkselectmulti2(frm, source_element_name_array, target_element_name, popupurl) {
        for (var i in source_element_name_array) {
            checkselectmulti(frm, source_element_name_array[i], target_element_name, popupurl);
        }
}

function setgroupinfo(src, target) {
        var group = src.value;
        target.value = group ? groups_info[group] : "";
}

function clearselect(frm, element_name) {
    var select = frm.elements[element_name];
    for (var i = 0; i < select.options.length; i++) {
        select.options[i].selected = false;
    }
}


// ------------------------------------------------------------------------- LOGIN -------------------------------------------------------------------------- //


function checklogin(frm) {
    var errors = 0;
    var message = 'The login page has the following errors:\n';
    
    if (isblank(frm.elements['username'].value)) {
        errors++;
        message += '\n-- User name is required\n'; 
    }
    if (isblank(frm.elements['password'].value)) {
        errors++;
        message += '\n-- Password is required\n';
    }
    if (errors > 0) {
        message += '\nPlease make the changes and log in again.\n';
        alert(message);
        return false;
    }
    return true;
}


// ----------------------------------------------------------------------- USER_HOME ------------------------------------------------------------------------ //

function checkmanagealerts(frm) {
    var removechecked = false;
    var errors        = 0;
    var removemessage = 'Are you sure you would like to remove these alerts and related data?\n';
    var message       = 'The manage alerts page has the following errors:\n';
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'checkbox' && frm.elements[i].name == 'remove_alerts') {
	    if (frm.elements[i].checked == true) {
	        removechecked  = true;
	    }
	}
    }
    
    if (!removechecked) {
        errors++;
	message += '\n-- No alerts are selected to be removed\n';
    }
    
    if (removechecked && !confirm(removemessage + '\n')) return false;
    
    if (errors > 0) {
        message += '\nPlease make the changes and manage alerts again.\n';
        alert(message);
        return false;
    }
    return true;
}

// ------------------------------------------------------------------- USER_INFO/REGISTER ------------------------------------------------------------------- //


function labfunctions(run, labselect, labfields) {
    var frm            = labselect.form;
    var option_new_lab = document.getElementById('option_new_lab');
    var fieldnames     = {'pi_name': 1, 'pi_email': 1, 'institution': 1, 'institute_url': 1, 'address': 1, 
                          'lab_url': 1, 'postcode': 1, 'city': 1,        'state': 1,         'country_id': 1};
    
    switch(run) {
        // clear any previous new labnames added
        case 'clear_new_labnames':
            var new_index;
            if (option_new_lab) new_index = option_new_lab.index;
	    if (new_index) {
                for (var i = labselect.options.length - 1; i > new_index; i--) labselect.options[i] = null;
	    }
	    break;
	
	// clear all laboratory input fields
	case 'clear_labfields':
            for (var fname in fieldnames) {
	        if (frm.elements[fname].type == 'select-one') frm.elements[fname].selectedIndex = 0;
	        else                                          frm.elements[fname].value = '';
	    }
	    break;
	
	// unlock all laboratory input fields
        case 'unlock_labfields':
            for (var i = 0; i < frm.elements.length; i++) {
	        if (frm.elements[i].name in fieldnames) {
	            if (frm.elements[i].type == 'select-one') frm.elements[i].disabled = false;
		    else                                      frm.elements[i].readOnly = false;
		    frm.elements[i].className = null;
	        }
	    }
	    break;
	
	// lock all laboratory input fields
	case 'lock_labfields':
	    for (var i = 0; i < frm.elements.length; i++) {
	        if (frm.elements[i].name in fieldnames) {
	            if (frm.elements[i].type == 'select-one') frm.elements[i].disabled = true;
		    else                                      frm.elements[i].readOnly = true;
		    frm.elements[i].className = 'disabled';
	        }
	    }
	    break;
	
	// fill laboratory input fields with DB values
	case 'filldb_labfields':
	    for (var fname in fieldnames) {
	        if (frm.elements[fname].type == 'select-one') frm.elements[fname].options[labfields[labselect.value][fname]].selected = true;
	        else                                          frm.elements[fname].value = labfields[labselect.value][fname];
	    }
	    break;
    }
}


function renamelab(frm, labfields, pi_labid) {
    var labselect = frm.elements['lab_id'];
    
    // make sure user can only rename lab for which s/he is PI of
    if (labselect.value == pi_labid) {
        var new_labname = prompt('Please enter your new lab name:', labfields[pi_labid]['name']);
	if (new_labname) {
	    new_labname = clean_whitespace(new_labname);
	    
	    // check for duplicate lab name
	    var duplicate = false;
	    for (var lab_id in labfields) {
	        if (lab_id != pi_labid && new_labname.toLowerCase() == labfields[lab_id]['name'].toLowerCase()) {
		    duplicate = true;
		    break;
		}
	    }
	    
	    if (!duplicate && !isblank(new_labname) && !checknumber(new_labname)) {
	        labselect.options[labselect.selectedIndex].text = new_labname;
		
		// create/update new lab name hidden element
		var newname_hidden = document.getElementById('new_labname');
		if (newname_hidden) {
		    newname_hidden.value = new_labname;
		}
		else {
		    var new_hidden = document.createElement('input');
		    new_hidden.type  = 'hidden';
		    new_hidden.id    = 'new_labname';
                    new_hidden.name  = 'new_labname';
                    new_hidden.value = new_labname;
                    frm.appendChild(new_hidden);
		}
	    }
	    else {
	        alert('Improper lab name or lab name already in use! Please try a different lab name.');
		renamelab(frm, labfields, pi_labid);
	    }
	}
    }
    else {
        alert('Only the principal investigator of the lab can change lab information!');
    }
}


function checklab(labselect, labfields, pi_labid) {
    var frm            = labselect.form;
    var option_new_lab = document.getElementById('option_new_lab');
    
    if (option_new_lab && option_new_lab.selected == true) {
        var new_labname = prompt('Please enter your new lab name:', '');
        if (new_labname) {
	    new_labname = clean_whitespace(new_labname);
	    
	    // check for duplicate lab name
	    var duplicate = false;
	    for (var lab_id in labfields) {
	        if (new_labname.toLowerCase() == labfields[lab_id]['name'].toLowerCase()) {
		    duplicate = true;
		    break;
		}
	    }
	    
	    if (!duplicate && !isblank(new_labname) && !checknumber(new_labname)) {
	        labfunctions('clear_new_labnames', labselect, labfields);
		// make new lab name select element option
	        labselect.options[labselect.options.length] = new Option(new_labname, new_labname, false, true);
	    
                labfunctions('clear_labfields', labselect, labfields);
	        labfunctions('unlock_labfields', labselect, labfields);
	        
	        // make new lab hidden element
		var new_hidden = document.createElement('input');
		new_hidden.type  = 'hidden';
		new_hidden.id    = 'new_lab';
                new_hidden.name  = 'new_lab';
                new_hidden.value = new_labname;
                frm.appendChild(new_hidden);
	    }
	    else {
	        labfunctions('clear_new_labnames', labselect, labfields);
	    
	        // remove new lab hidden element if it exists
	        var other_hidden = document.getElementById('other_' + labselect.name);
                if (other_hidden) frm.removeChild(other_hidden);
	    
	        labfunctions('lock_labfields', labselect, labfields);
	        labfunctions('clear_labfields', labselect, labfields);
		
		alert('Improper lab name or lab name already in use! Please try a different lab name.');
	        checklab(labselect, labfields, pi_labid);
	    }
	}
	else {
	    labfunctions('clear_new_labnames', labselect, labfields);
	    
	    // remove new lab hidden element if it exists
	    var other_hidden = document.getElementById('other_' + labselect.name);
            if (other_hidden) frm.removeChild(other_hidden);
	    
	    labfunctions('lock_labfields', labselect, labfields);
	    labfunctions('clear_labfields', labselect, labfields);
	    
	    labselect.selectedIndex = 0;
	}
    }
    else {
        if (pi_labid && labselect.value == pi_labid) {
	    // change PI to 'yes' if user is selecting a lab for which s/he is the PI
	    // var pi_yes = document.getElementById('pi_yes');
	    // pi_yes.checked = true;
	    
	    labfunctions('unlock_labfields', labselect, labfields);
	}
	else {
	    // change PI to 'no' if user is selected a lab for which s/he is not the PI
	    // var pi_no  = document.getElementById('pi_no');
	    // pi_no.checked = true;
	    
	    labfunctions('lock_labfields', labselect, labfields);
	}
	
        labfunctions('clear_new_labnames', labselect, labfields);
	
	// remove new lab hidden element if it exists
	var other_hidden = document.getElementById('other_' + labselect.name);
        if (other_hidden) frm.removeChild(other_hidden);
	
	if (labselect.selectedIndex == 0) labfunctions('clear_labfields', labselect, labfields);
	else                              labfunctions('filldb_labfields', labselect, labfields);
    }
}


function checkuserinfo(frm, is_groups) {
    var errors  = 0;
    var message = 'The registration page has the following errors:\n';
    
    // remove extra whitespace from text and text area fields
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'text') {
	    frm.elements[i].value = clean_whitespace(frm.elements[i].value);
	}
	else if (frm.elements[i].type == 'textarea') {
	    clean_freetext(frm.elements[i].value);
	    frm.elements[i].value = frm.elements[i].value.replace(/(\s)+/g, '$1');
	}
    }
    
    // login
    if (isblank(frm.elements['usernme'].value)) {
        errors++;
	message += '\n-- User name is required\n';
    }
    else if (frm.elements['usernme'].value.length>15) {
	    errors++;
	    message += '\n-- Your login cannot be longer than 15 characters\n';
    }
    else if (frm.elements['usernme'].value.search(/\W/) != -1) {
	errors++;
	message += '\n-- Your login cannot contain any special characters or spaces ( ,:;!\'"-.()?@*{}[] )\n';
    }
    
    // password & confirmation
    if (isblank(frm.elements['password'].value)) {
        errors++;
	message += '\n-- Password is required\n';
    }
    else {
	if (frm.elements['password'].value.search(/\s/) != -1) {
	    errors++;
	    message += '\n-- Your password cannot contain any spaces\n';
	}
	else if (frm.elements['password'].value.length<6) {
	    errors++;
	    message += '\n-- Your password must be at least 6 characters long\n';
	}
	else if (frm.elements['password'].value != frm.elements['confirm_pass'].value) {
	    errors++;
	    message += '\n-- Your password and password confirmation are not identical\n';
	}
    }
    
    // first name
    if (isblank(frm.elements['first_name'].value)) {
        errors++;
	message += '\n-- First name is required\n';
    }
    else if (frm.elements['first_name'].value.search(/[^a-zA-Z\- ]/) != -1) {
	errors++;
	message += '\n-- Your first name cannot contain any special characters or numbers ( ,:;!\'".()?@*{}[]0-9 )\n';
    }
    
    // middle name
    if (isblank(frm.elements['middle_name'].value)) {
	if (frm.elements['middle_name'].value.search(/[^a-zA-Z\- ]/) != -1) {
	    errors++;
	    message += '\n-- Your middle name cannot contain any special characters or numbers ( ,:;!\'".()?@*{}[]0-9 )\n';
	}
    }
    
    // last name
    if (isblank(frm.elements['last_name'].value)) {
        errors++;
	message += '\n-- Last name is required\n';
    }
    else if (frm.elements['last_name'].value.search(/[^a-zA-Z\- ]/) != -1) {
	errors++;
	message += '\n-- Your last name cannot contain any special characters or numbers ( ,:;!\'".()?@*{}[]0-9 )\n';
    }
    
    // position
    if (isblank(frm.elements['position'].value)) {
        errors++;
	message += '\n-- Job position is required\n';
    }
    
    // phone number
    if (isblank(frm.elements['phone'].value)) {
        errors++;
	message += '\n-- Phone number is required\n';
    }
    else if (frm.elements['phone'].value.search(/^\+[\d \(\)\-\/]+$/) == -1) {
	errors++;
	message += '\n-- Phone number must be composed of a leading +, numbers, (, ), -, and spaces\n';
    }
    
    // fax number (not required)
    if (!isblank(frm.elements['fax'].value) && frm.elements['fax'].value.search(/^\+[\d \(\)\-\/]+$/) == -1) {
	errors++;
	message += '\n-- Fax number must be composed of a leading +, numbers, (, ), -, and spaces\n';
    }
    
    // email
    if (isblank(frm.elements['email'].value)) {
        errors++;
	message += '\n-- Email address is required\n';
    }
    else if (frm.elements['email'].value.search(/^[a-zA-Z0-9_\-\.\+]+@[a-zA-Z0-9_\-\.\+]+$/) == -1) {
	errors++;
	message += '\n-- Email address is not in a valid format\n';
    }
    
    // pi email
    if (isblank(frm.elements['pi_email'].value)) {
        errors++;
	message += '\n-- Principal investigator email address is required\n';
    }
    else if (frm.elements['pi_email'].value.search(/^[a-zA-Z0-9_\-\.\+]+@[a-zA-Z0-9_\-\.\+]+$/) == -1) {
	errors++;
	message += '\n-- Principal investigator email address is not in a valid format\n';
    }
    
    
    if (frm.elements['lab_name'] || frm.elements['lab_id']) {
        // laboratory name
        if (frm.elements['lab_name'] && isblank(frm.elements['lab_name'].value)) {
            errors++;
	    message += '\n-- Laboratory name is required\n';
        }
        
	// laboratory selection
	if (frm.elements['lab_id'] && frm.elements['lab_id'].selectedIndex == 0) {
            errors++;
	    message += '\n-- No laboratory selected\n';
        }
	
        // principal investigator
        if (isblank(frm.elements['pi_name'].value)) {
            errors++;
	    message += '\n-- Principal investigator name is required\n';
        }
	else if (frm.elements['pi_email'].value.toLowerCase() == frm.elements['email'].value.toLowerCase()) {
	    var full_name = frm.elements['first_name'].value + ' ' + frm.elements['middle_name'].value + ' ' + frm.elements['last_name'].value;
	    full_name = full_name.replace(/\s+/g, ' ');
	    if (full_name != frm.elements['pi_name'].value) { // case-sensitive match
	        errors++;
		message += '\n-- Full name does not match principal investigator name\n';
	    }
	}
        
        // institution
        if (isblank(frm.elements['institution'].value)) {
            errors++;
	    message += '\n-- Institution name is required\n';
        }
        
        // address
        if (isblank(frm.elements['address'].value)) {
            errors++;
	    message += '\n-- Address is required\n';
        }
        
        // postcode
        if (isblank(frm.elements['postcode'].value)) {
            errors++;
	    message += '\n-- Post code is required\n';
        }
        else if (frm.elements['postcode'].value.search(/[^a-zA-Z0-9\-]/) != -1) {
	    errors++;
	    message += '\n-- Post code is not in a valid format\n';
        }
        
        // city
        if (isblank(frm.elements['city'].value)) {
            errors++;
	    message += '\n-- City is required\n';
        }
        else if (frm.elements['city'].value.search(/[^a-zA-Z \-]/) != -1) {
	    errors++;
	    message += '\n-- City should only contain alphabet letters, dashes, or spaces\n';
        }
        
        // country
        if (frm.elements['country_id'].selectedIndex == 0) {
            errors++;
	    message += '\n-- No country selected\n';
        }
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and submit user information again.\n';
        alert(message);
        return false;
    }
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'select-one') frm.elements[i].disabled = false;
    }
    
    if (frm.name == 'user_registration' && frm.elements['lab_name']) {
        alert('You will receive an email from the MIMAS Administrator when your registration is approved. Thank you!');
    }
    
    if (is_groups) {
		var selected         = frm.elements['groups'];
		for (var i = 0; i < selected.options.length; i++) {
			selected[i].selected = true;
		}
		if (selected.options.length == 0) {
			message += '\nGroups field cannot be empty.\n';
			alert(message);
			return false;
		}
		var selected         = frm.elements['facilities'];
		for (var i = 0; i < selected.options.length; i++) {
			selected[i].selected = true;
		}
    }

    return true;
}


// ----------------------------------------------------------------------- NEW_FACTOR ----------------------------------------------------------------------- //


function togglefactorunits(is_numeric) {
    var orig_width  = 350 + 10;  // have to add these dimensions to original window dimensions
    var orig_height = 165 + 50;
    var tr_numeric  = is_numeric.parentNode.parentNode;
    var tr_units    = document.getElementById('tr_factor_units');
    
    if (is_numeric.value == 1) {
        tr_units.className = null;
	tr_numeric.cells[0].className = 'cell01';
	tr_numeric.cells[1].className = 'cell02w100pct';
	window.resizeTo(orig_width, orig_height + 30);
    }
    else {
        tr_units.className = 'hidden';
	tr_numeric.cells[0].className = 'cell03';
	tr_numeric.cells[1].className = 'cell04w100pct';
	window.resizeTo(orig_width, orig_height);
    }
}


function checknewfactor(frm) {
    var errors    = 0;
    var message   = 'The new experimental factor page has the following errors:\n';
    
    // NEW EXPERIMENTAL FACTOR NAME
    frm.elements['new_factor_name'].value = clean_whitespace(frm.elements['new_factor_name'].value);
    if (isblank(frm.elements['new_factor_name'].value)) {
        errors++;
	message += '\n-- Experimental factor name is required\n';
    }
    else if (checknumber(frm.elements['new_factor_name'].value)) {
        errors++;
	message += '\n-- Experimental factor name cannot be numeric\n';
    }
    
    // IS NUMERIC RADIO BUTTON
    var numeric_yes = document.getElementById('numeric_yes');
    var numeric_no  = document.getElementById('numeric_no');
    if (!numeric_yes.checked && !numeric_no.checked) {
        errors++;
	message += '\n-- Specifying whether the new experimental factor is numeric or not is required\n';
    }
    
    var targetselect = opener.document.getElementById('exp_factors_target');
    var sourceselect = opener.document.getElementById('exp_factors_source');
    
    for (var i = 0; i < targetselect.options.length; i++) {
        if (targetselect.options[i].text.toLowerCase() == frm.elements['new_factor_name'].value.toLowerCase()) {
	    errors++;
	    message += '\n-- The new factor you have specifed already exists\n';
	}
    }
    for (var i = 0; i < sourceselect.options.length; i++) {
        if (sourceselect.options[i].text.toLowerCase() == frm.elements['new_factor_name'].value.toLowerCase()) {
	    errors++;
	    message += '\n-- The new factor you have specifed already exists\n';
	}
    }
    
    
    if (errors > 0) {
        message += '\nPlease make the changes and create the experimental factor again.\n';
        alert(message);
        return false;
    }
    
    createuseroption(targetselect, frm.elements['new_factor_name'].value, false, opener);
    
    var name_hidden      = opener.document.createElement('input');
    name_hidden.type     = 'hidden';
    name_hidden.name     = 'other_factor_names';
    name_hidden.value    = frm.elements['new_factor_name'].value;
    
    var numeric_hidden   = opener.document.createElement('input');
    numeric_hidden.type  = 'hidden';
    numeric_hidden.name  = 'other_factor_is_numeric';
    numeric_hidden.value = numeric_yes.checked ? 1 : 0;
    
    var units_hidden     = opener.document.createElement('input');
    units_hidden.type    = 'hidden';
    units_hidden.name    = 'other_factor_unit_group_ids';
    units_hidden.value   = frm.elements['exp_factor_units'].value;
    
    opener.document.forms['exp_info'].appendChild(name_hidden);
    opener.document.forms['exp_info'].appendChild(numeric_hidden);
    opener.document.forms['exp_info'].appendChild(units_hidden);
    
    window.close();
    sortoptions(targetselect, opener);
    return true;
}


// -------------------------------------------------------------------- SAMPLE_RELATIONS -------------------------------------------------------------------- //


function checkrelationsetup(frm, dbconditions) {
    var errors            = 0;
    var removeconditions  = false;
    var removemessage     = 'Are you sure you would like to remove these experimental condition(s) and ALL associated meta-data?\n';
    var message           = 'The sample relationship setup page has the following errors:\n';
    var condition_ids     = frm.elements['condition_ids'];
    var names             = new Object();
    var keep_ids          = new Object();
    
    // experimental condition names
    if (condition_ids.options.length == 0) {
        errors++;
	message += '\n-- No experimental condition name(s) created\n';
    }
    for (var i = 0; i < condition_ids.options.length; i++) {
        if (names[condition_ids.options[i].text]) {
	    errors++;
	    message += '\n-- The experimental condition name "' + condition_ids.options[i].text + '" is duplicated\n';
	}
	else {
	    names[condition_ids.options[i].text] = true;
	    keep_ids[condition_ids.options[i].value] = true;
	}
    }
    for (var condition_id in dbconditions) {
        if (!keep_ids[condition_id]) {
	    removemessage += '\n"' + dbconditions[condition_id] + '"\n';
	    removeconditions = true;
	}
    }
    
    if (removeconditions && errors == 0 && !confirm(removemessage + '\n')) return false;
    
    if (errors > 0) {
        message += '\nPlease make the changes and setup relationships again.\n';
        alert(message);
        return false;
    }
    
    // make all experimental conditions selected & create hidden elements for new conditions
    for (var i = 0; i < condition_ids.options.length; i++) {
        if (condition_ids.options[i].value == 0) {
	    var new_hidden   = document.createElement('input');
	    new_hidden.type  = 'hidden';
            new_hidden.name  = 'new_condition_names';
	    new_hidden.value = condition_ids.options[i].text;
            frm.appendChild(new_hidden);
	}
	condition_ids.options[i].selected = true;
    }
    return true;
}


function checksamplerelations(frm, dbconditions) {
    var errors             = 0;
    var message            = 'The sample relationship page has the following errors:\n';
    var conditions_picked  = new Array();
    var dbconditions_used  = new Object();
    var replcounts         = new Object();
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'select-one') {
	    if (frm.elements[i].selectedIndex == 0 && errors == 0) {
	        errors++;
		message += '\n-- A experimental condtion and array must be selected for every sample\n';
	    }
            else if (frm.elements[i].name == 'condition_ids') {
                dbconditions_used[frm.elements[i].value] = true;
                conditions_picked.push(frm.elements[i].value);
                var str = conditions_picked[conditions_picked.length - 1];
                replcounts[str] = replcounts[str] ? replcounts[str] + 1 : 1;
            }
	}
    }
    
    for (var condition_id in dbconditions) {
        if (!dbconditions_used[condition_id]) {
	    errors++;
	    message += '\n-- No samples are associated with experimental condition "' + dbconditions[condition_id] + '"\n';
	}
    }
    
    if (errors == 0) {
	var goodcount;
	var replerror = 0;
	var replmessage = '\n-- Replicate numbers do not equate:\n';
        for (var cond_array in replcounts) {

        //if a condition has only one 'replicate' we should show '0 replicate' instead of
        //'1 replicate' but this is much too confusing to users
	    //if (replcounts[cond_array] == 1) replcounts[cond_array] = 0;
	    
	    if   (goodcount != null && goodcount != replcounts[cond_array]) replerror++;
	    else                                                            goodcount = replcounts[cond_array];
	    
	    var ids       = cond_array.split(':', 2);
	    replmessage += '\nCondition: '  + dbconditions[ids[0]]    +
	                   '\nReplicates: '       + replcounts[cond_array]  + '\n';
        }
	if (replerror && !confirm(replmessage + '\nAre you sure this is correct and you would like to continue?\n')) {
	    return false;
	}
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and submit relationships again.\n';
        alert(message);
        return false;
    }
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'select-one') frm.elements[i].disabled = false;
    }
    return true;
}


function addcondition(frm) {
    var condition_input = frm.elements['condition_input'];
    var condition_ids   = frm.elements['condition_ids'];
    var duplicate       = false;
    
    if (condition_input.value && !isblank(condition_input.value)) {
        condition_input.value = clean_whitespace(condition_input.value);
	
        for (var i = 0; i < condition_ids.options.length; i++) {
	    if (condition_ids.options[i].text.toLowerCase() == condition_input.value.toLowerCase()) {
	        duplicate = true;
		break;
	    }
	}
        if (!duplicate) condition_ids.options[condition_ids.options.length] = new Option(condition_input.value, 0, false, false);
    }
    condition_input.value = '';
    
    // don't sort alphabetically because we let user decide order of the experimental conditions
    // sortoptions(condition_ids, window);
}


function renamecondition(frm) {
    var condition_ids = frm.elements['condition_ids'];
    
    for (var i = 0; i < condition_ids.options.length; i++) {
        if (condition_ids.options[i].selected == true) {
            var duplicate = false;
            var new_condition_name = prompt('Please enter a new experimental condition name for "' + condition_ids.options[i].text + '":', condition_ids.options[i].text);
	    if (new_condition_name && !isblank(new_condition_name)) {
                new_condition_name = clean_whitespace(new_condition_name);
		
		for (var j = 0; j < condition_ids.options.length; j++) {
             if (i == j) continue;

		    if (condition_ids.options[j].text == new_condition_name) {
		        duplicate = true;
		        break;
		    }
	        }
	        if (!duplicate) {
		    if (condition_ids.options[i].value != 0) {
		        var newname_hidden = document.getElementById('newname_' + condition_ids.options[i].value);
	                if (newname_hidden) {
	                    newname_hidden.value = new_condition_name;
	                }
	                else {
	                    var new_hidden   = document.createElement('input');
		            new_hidden.type  = 'hidden';
                            new_hidden.name  = 'rename_conditions';
                            new_hidden.value = condition_ids.options[i].value;
                            frm.appendChild(new_hidden);
		
		            new_hidden       = document.createElement('input');
		            new_hidden.type  = 'hidden';
		            new_hidden.id    = 'newname_' + condition_ids.options[i].value;
                            new_hidden.name  = 'new_names';
                            new_hidden.value = new_condition_name;
                            frm.appendChild(new_hidden);
	                }
		    }
	            condition_ids.options[i].text      = new_condition_name;
		    condition_ids.options[i].className = 'italic';
	        }
	        else {
	            alert('"' + new_condition_name + '" already exists! Please use another name.');
		    i--;
	        }
	    }
	}
    }
}


function deletecondition(frm) {
    var condition_ids = frm.elements['condition_ids'];
    
    for (var i = condition_ids.options.length - 1; i >= 0; i--) {
        if (condition_ids.options[i].selected == true) condition_ids.options[i] = null;
    }
}


function moveconditionup(frm) {
    var condition_ids = frm.elements['condition_ids'];
    var begin_options = new Array();
    
    var i = 0;
    while (i < condition_ids.options.length) {
        if (condition_ids.options[i].selected == true) {
	    var selected_opt_text  = condition_ids.options[i].text;
	    var selected_opt_value = condition_ids.options[i].value;
	    if (i == 0) {
	        begin_options.push(new Option(selected_opt_text, selected_opt_value, false, true));
		condition_ids.options[i] = null;
		i = 0;
		continue;
	    }
	    else {
	        var prev_opt_text   = condition_ids.options[i - 1].text;
	        var prev_opt_value  = condition_ids.options[i - 1].value;
		condition_ids.options[i - 1] = new Option(selected_opt_text, selected_opt_value, false, true);
	        condition_ids.options[i]     = new Option(prev_opt_text,     prev_opt_value,     false, false);
	    }
	}
	
	i++;
    }
    
    for (var i = 0; i < begin_options.length; i++) {
        condition_ids.add(begin_options[i], navigator.appName == 'Microsoft Internet Explorer' ? condition_ids.length : null);
    }
}


function moveconditiondown(frm) {
    var condition_ids = frm.elements['condition_ids'];
    var end_options   = new Array();
    
    var i = condition_ids.options.length - 1;
    while (i >= 0) {
        if (condition_ids.options[i].selected == true) {
	    var selected_opt_text  = condition_ids.options[i].text;
	    var selected_opt_value = condition_ids.options[i].value;
	    if (i == (condition_ids.options.length - 1)) {
	        end_options.push(new Option(selected_opt_text, selected_opt_value, false, true));
		condition_ids.options[i] = null;
		i = condition_ids.options.length - 1;
		continue;
	    }
	    else {
	        var next_opt_text  = condition_ids.options[i + 1].text;
	        var next_opt_value = condition_ids.options[i + 1].value;
		condition_ids.options[i + 1] = new Option(selected_opt_text, selected_opt_value, false, true);
	        condition_ids.options[i]     = new Option(next_opt_text,     next_opt_value,     false, false);
	    }
	}
	
	i--;
    }
    
    for (var i = 0; i < end_options.length; i++) {
        condition_ids.add(end_options[i], navigator.appName == 'Microsoft Internet Explorer' ? 0 : condition_ids.options[0]);
    }
}


function syncConditionColor(srcName, destName) {
	var src = document.getElementById(srcName);
	if (src.value.match(/^([A-Za-z0-9]{3}([A-Za-z0-9]{3})?)?$/)) {
		var dest = document.getElementById(destName);
		if (src.value != '')
			dest.style.backgroundColor = '#' + src.value;
		else
			dest.style.background = 'none';

		src.style.backgroundColor = 'white';

	}
	else {
		src.style.backgroundColor = '#FF9999';
	}
}

function pickConditionColor(srcName, destName, paletteName) {
	var dest = document.getElementById(destName);
	var palette = document.getElementById(paletteName);

	var COLS = 9;

	var html = "";
	html += "<div style='position:absolute; background: white'>";
	html += "<table>";
	html += "<tr>";
    for (var i = 0; i < paletteobj.length; i++) {
		var color = paletteobj[i];
		if (i > 0 && i % COLS == 0)
			html += "</tr><tr>";
		html += "<td style='background-color:#" + color + "; width:10px; height:10px; border:solid 1px' onclick=\"pickConditionColorPicked('" + srcName + "','" + destName + "','" + paletteName + "','" + color + "')\"></td>";
	}
	html += "</tr>";
	html += "</table>";
	html += "</div>";

	palette.innerHTML = html;
}

function pickConditionColorPicked(srcName, destName, paletteName, color) {
	var src = document.getElementById(srcName);
	var palette = document.getElementById(paletteName);
	var dest = document.getElementById(destName);
	palette.innerHTML = "";

	src.value = color;
	syncConditionColor(srcName, destName);
}



// ---------------------------------------------------------------- EXP_INFO & SAMPLE_ATTRS ---------------------------------------------------------------- //


function checkagetype(agetypeselect) {
    var tr_age      = document.getElementById('tr_age');
    var tr_min_age  = document.getElementById('tr_min_age');
    var tr_max_age  = document.getElementById('tr_max_age');
    var tr_age_init = document.getElementById('tr_age_init');
    
    var type = agetypeselect.options[agetypeselect.selectedIndex].text.toLowerCase();

    if (type == 'specified range') {
        tr_age.className      = 'hidden';
	tr_min_age.className  = null;
	tr_max_age.className  = null;
	tr_age_init.className = null;
    }
    else if (type == 'specified single' || type == 'specified mean' || type == 'specified median') {
        tr_age.className      = null;
	tr_min_age.className  = 'hidden';
	tr_max_age.className  = 'hidden';
	tr_age_init.className = null;
    }
    else {
        tr_age.className      = 'hidden';
	tr_min_age.className  = 'hidden';
	tr_max_age.className  = 'hidden';
	tr_age_init.className = 'hidden';
    }
}


function checkfillcondition(fillconditionselect, samples, selected_sample_id) {
    var fillsampleselect = document.getElementById('fill_sample_select');
    
    // clear all options and put default first option
    fillsampleselect.options.length = 0;
    fillsampleselect.options[fillsampleselect.options.length] = new Option('\u2193 now pick a sample \u2193', '', false, false);
    
    for (var i = 0; i < samples.length; i++) {
        if (samples[i]['sample_id'] != selected_sample_id) {
	    if (fillconditionselect.selectedIndex == 0 || samples[i]['condition_id'] == fillconditionselect.value) {
	        fillsampleselect.options[fillsampleselect.options.length] = new Option(samples[i]['name'], samples[i]['sample_id'], false, false);
	    }
	}
    }
}


function checkfillsample(fillsampleselect, url) {
    if   (fillsampleselect.selectedIndex == 0) location.replace(url);
    else                                       location.replace(url + '&fill_sample_id=' + fillsampleselect.value);
}


function checkattrs(frm, attributes) {
    var errors    = 0;
    var message   = 'The experiment/sample attributes page has the following errors:\n';
    var commonref = false;

    var required_radio = new Array();
    for (var i = 0; i < frm.elements.length; i++) {
        // check value fields
	if (attributes[frm.elements[i].name]) {
            // check for required attributes
	    if (attributes[frm.elements[i].name].required) {
	        if (((frm.elements[i].type == 'text' || frm.elements[i].type == 'textarea') && isblank(frm.elements[i].value)) ||
		    ( frm.elements[i].type == 'select-one'      && frm.elements[i].selectedIndex  == 0)                        ||
		    ( frm.elements[i].type == 'select-multiple' && frm.elements[i].options.length == 0)
                ) {
	            errors++;
		    message += '\n-- The field "' + attributes[frm.elements[i].name].name + '" is required\n';
	        }
                //radio buttons cannot be checked at once; must iterate through all form fields
                else if (frm.elements[i].type == 'radio') {
                    var checked = frm.elements[i].checked ? "yes" : "no";
                    if (!required_radio[frm.elements[i].name]) {required_radio[frm.elements[i].name] = new Array() }
                    required_radio[frm.elements[i].name][checked] = 1;
                }
	    }
	    // check numeric fields
	    if (attributes[frm.elements[i].name].is_numeric && !isblank(frm.elements[i].value) && !checknumber(frm.elements[i])) {
	        errors++;
		message += '\n-- The field "' + attributes[frm.elements[i].name].name + '" needs to be numeric\n';
	    }
        }
	// check units fields
	else if (frm.elements[i].name.search(/^attr_units_\d+$/i) != -1) {
	    var units_field  = frm.elements[i].name.match(/^attr_units_(\d+)$/i);
	    var other_exists = document.getElementById('other_' + units_field[0]);
	    if (isblank(frm.elements[i].value)) {
	        errors++;
	        message += '\n-- The field "' + attributes['attr_values_' + units_field[1]].name + '" needs units\n';
	    }
	    else {
	        if (other_exists) {
	            if (checknumber(frm.elements[i])) {
	                errors++;
	                message += '\n-- Units cannot be numeric in field "' + attributes['attr_values_' + units_field[1]].name + '"\n';
		    }
	        }
	        else {
	            if (!checknumber(frm.elements[i])) {
		        errors++;
		        message += '\n-- Units error in field "' + attributes['attr_values_' + units_field[1]].name + '"\n';
		    }
	        }
	    }
        }
    }

    for (var name in required_radio) {
        if (!required_radio[name]["yes"]) {
            errors++;
            message += '\n-- The field "' + attributes[name].name + '" is required\n';
        }
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and submit experiment/sample attributes again.\n';
        alert(message);
        return false;
    }
    
    // enable any disabled fields, select library options in target select-multiple elements, 
    // deselect user-defined options in any select element, and create hidden elements for user-defined options
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].disabled) frm.elements[i].disabled = false;
	if (frm.elements[i].type == 'select-one' || frm.elements[i].type == 'select-multiple') {
	    if (frm.elements[i].type == 'select-multiple' && attributes[frm.elements[i].name]) {
	        for (var j = 0; j < frm.elements[i].options.length; j++) {
	            frm.elements[i].options[j].selected = true;
	        }
	    }
	    
	    var user_optgroup = document.getElementById('optgroup_user_' + frm.elements[i].name);
	    if (user_optgroup) {
	        for (var j = 0; j < user_optgroup.childNodes.length; j++) {
		    if (frm.elements[i].type == 'select-one' && user_optgroup.childNodes[j].selected == true) {
		        createuserhidden(frm.elements[i], user_optgroup.childNodes[j].text, window);
			frm.elements[i].selectedIndex = 0;
                    }
		    else if (frm.elements[i].type == 'select-multiple' && attributes[frm.elements[i].name]) {
		        createuserhidden(frm.elements[i], user_optgroup.childNodes[j].text, window);
			user_optgroup.childNodes[j].selected = false;
		    }
		}
	    }
	}	
    }
    
    return true;
}


function checkpermissions(frm) {
    var errors    = 0;
    var message   = 'The experiment/sample attributes page has the following errors:\n';
    var commonref = false;

    var fields = new Array('read_groups', 'write_groups');

    for (var k = 0; k < fields.length; k++) {
        var selected         = frm.elements[fields[k]];
        if (selected) {
            for (var i = 0; i < selected.options.length; i++) {
                selected[i].selected = true;
            }
        }
    }

    if (errors > 0) {
        message += '\nPlease make the changes and submit experiment/sample attributes again.\n';
        alert(message);
        return false;
    }
    return true;
}


// ---------------------------------------------------------------------- FILE_UPLOAD ----------------------------------------------------------------------- //


function removefilerow(removebutton) {
    var table = document.getElementById('upload_file_table');
    var tr, td, td_browse, td_add, add_html;
    
    td_add    = document.getElementById('add_files_cell');
    add_html  = td_add.innerHTML;
    
    removebutton.parentNode.parentNode.parentNode.removeChild(removebutton.parentNode.parentNode);
    
    tr = table.rows[table.rows.length - 1];
    
    td_browse           = tr.cells[0];
    td_browse.id        = 'file_browse_cell';
    td_browse.className = 'cell03w100pct';
    
    if (table.rows.length == 1) tr.deleteCell(tr.cells.length - 1);
    
    td           = tr.cells[tr.cells.length - 1];
    td.innerHTML = add_html;
    td.id        = 'add_files_cell';
}


function addfilerows(frm, maxfiles) {
    var table = document.getElementById('upload_file_table');
    var tr, td, td_browse, td_add, browse_html, add_html;
    var num_rows_to_add = 1;
    
    if (table.rows.length == 1) {
        var bad_user_value;
	do {
	    var num_total_rows = prompt('How many files in total would you like to upload?\nPlease enter a positive integer between 1 - ' + maxfiles + ':', '');
	    if (num_total_rows && !isblank(num_total_rows)) {
	        num_total_rows = clean_whitespace(num_total_rows);
		if (isinteger(num_total_rows) && num_total_rows > 0 && num_total_rows <= maxfiles) {
		    bad_user_value  = false;
		    num_rows_to_add = num_total_rows - 1;
	            
		    if (num_rows_to_add > 0) {
	                tr = table.rows[table.rows.length - 1];
	                
                        td           = tr.insertCell(tr.cells.length);
	                td.innerHTML = '<img width="1" height="1" alt="" src="/images/spacer.gif">';
	                td.className = 'cell04';
		    }
		}
		else {
		    bad_user_value = true;
		    alert('Value is not an integer in the range of 1 - ' + maxfiles + '!  Please try again.');
		}
	    }
	    else {
	        bad_user_value  = false;
	        num_rows_to_add = 0;
	    }
	} while (bad_user_value);
    }
    
    for (var i = 1; i <= num_rows_to_add; i++) {
        td_browse           = document.getElementById('file_browse_cell');
        browse_html         = td_browse.innerHTML;
        td_browse.id        = null;
        td_browse.className = 'cell01w100pct';
        
        td_add              = document.getElementById('add_files_cell');
        add_html            = td_add.innerHTML;
        td_add.innerHTML    = '<img width="1" height="1" alt="" src="/images/spacer.gif">';
        td_add.id           = null;
        td_add.className    = 'cell04';
	
	tr = table.insertRow(table.rows.length);
	
	td           = tr.insertCell(tr.cells.length);
        td.innerHTML = browse_html;
        td.className = 'cell03w100pct';
        td.id        = 'file_browse_cell';
	
	td           = tr.insertCell(tr.cells.length);
        td.innerHTML = '<input class="button01w50" type="button" name="removefile" value="REMOVE" onClick="removefilerow(this)">';
        td.className = 'remove01';
	
	td           = tr.insertCell(tr.cells.length);
        td.innerHTML = add_html;
        td.id        = 'add_files_cell';
	
	// Scroll web page down so that add file upload field remains visible if we are adding 1-10 rows
        if (i <= 10) window.scrollBy(0, 50);
    }
}


function addsample(frm) {
    
    var bad_user_value;
	do {
	    var sample_name = prompt('Sample name:', '');
	    if (sample_name && !isblank(sample_name)) {
	        sample_name = clean_whitespace(sample_name);
		if (sample_name.match(/^[\w.-]+$/)) {
		    bad_user_value  = false;
            frm.elements['add_sample'].value = sample_name;
            frm.submit();
		}
		else {
		    bad_user_value = true;
		    alert('Illegal sample name!  Please try again.');
		}
	    }
	    else {
	        bad_user_value  = false;
	    }
	} while (bad_user_value);
    
}


function checkmerge(select, frm) {
    var values = {};
    for (var i = 0; i < frm.elements.length; i++) {
        if (!isblank(frm.elements[i].value) && frm.elements[i].name.indexOf('merge_') == 0) {
		values[frm.elements[i].value] = 1;
	}
    }
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].name.indexOf('merge_') == 0) {
		var select1 = frm.elements[i];
		for (var j = 0; j < select1.options.length; j++) {
		if (!select1.options[j].selected && values[select1.options[j].value] == 1) {
			select1.options[j].disabled = true;
		}
		else {
			select1.options[j].disabled = false;
		}
	}
	}
    }
}


function checkremovefiles(frm) {
    var removechecked = false;
    var errors = 0;
    var message = 'The remove samples page has the following errors:\n';
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].name == 'remove_samples') {
	    if (frm.elements[i].checked == true) removechecked = true;
	}
    }
    
    if (!removechecked) {
        if (!frm.elements['publish_germonline_input'].value) {
            errors++;
            message += '\n-- No samples are selected to be removed\n';
        }
    } 
    else if (!confirm('Are you sure you would like to remove these files and ALL associated meta-data?')) {
	return false;
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and remove samples again.\n';
        alert(message);
        return false;
    }
    
    return true;
}




function checkindfileupload(frm, dbfiles, progressurl, maxfiles) {
    var errors         = 0;
    var message        = 'The file upload page has the following errors:\n';
    var fieldnum       = 0;
    var orig_filenames = new Object();
    var lc_upfiles     = new Object();
    var seen_compressed = 0;
    
    var lc_dbfiles = new Object();
    for (var filename in dbfiles) {
        lc_dbfiles[filename.toLowerCase()] = new Object();
	for (var ext in dbfiles[filename]) {
	    lc_dbfiles[filename.toLowerCase()][ext.toUpperCase()] = dbfiles[filename][ext];
	}
    }
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'file') {
	    fieldnum++;
	    if (isblank(frm.elements[i].value)) {
	        errors++;
		message += '\n-- Empty file path in upload field #' + fieldnum + '\n';
	    }
	    else {
	        var filespecs = frm.elements[i].value.match(/^(?:(?:.+)(?:\/|\\))?(.+)\.(.+)$/);
		if (!filespecs) {
		    errors++;
		    message += '\n-- Invalid file path in upload field #' + fieldnum + ': ' + frm.elements[i].value + '\n';
		}
		else {
		    var filename = filespecs[1];
		    var ext      = filespecs[2];
		    var is_compressed = frm.elements[i].value.search(/\.(TAR|TAR\.GZ|TGZ|ZIP)$/i) != -1;
		    seen_compressed |= is_compressed;

		    if (!filename || !ext || (ext.search(/^(CEL|TXT|RMA|GMA|GFF|TAR|GZ|TGZ|ZIP)$/i) == -1)) {
		        errors++;
			message += '\n-- Invalid file in upload field #' + fieldnum + ': ' + frm.elements[i].value + '\n';
		    }
		    else if ((lc_dbfiles[filename.toLowerCase()] && lc_dbfiles[filename.toLowerCase()][ext.toUpperCase()]) ||
		             (lc_upfiles[filename.toLowerCase()] && lc_upfiles[filename.toLowerCase()][ext.toUpperCase()])) {
				var overwrite = frm.elements['overwrite_files'].checked;
				if (!overwrite) {
					errors++;
					message += '\n-- Duplicate or already uploaded file in upload field #' + fieldnum + ': ' + filename + '.' + ext + '\n';
				}
		    }
		    else {
		        if (!lc_upfiles[filename.toLowerCase()]) lc_upfiles[filename.toLowerCase()] = new Object();
		        lc_upfiles[filename.toLowerCase()][ext.toUpperCase()] = 1;
			orig_filenames[filename.toLowerCase()] = filename;
		    }
		}
	    }
	}
    }
    
    if (fieldnum > maxfiles) {
        errors++;
	message += '\n-- Number of files to upload greater than maximum allowed per attempt (' + maxfiles + ')\n';
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and upload files again.\n';
        alert(message);
        return false;
    }
    
    var fileuploadarea     = document.getElementById('file_upload_area');
    var uploadprogressarea = document.getElementById('upload_progress_area');
    fileuploadarea.className     = 'hidden';
    uploadprogressarea.className = null;
    progressupdate(0);
    
    // global "file_progress_win" so we can close it easily in body onunload
    // file_progress_win = window.open(progressurl, 'file_progress', 'width=300,height=100,status=no,resizable=no,scrollbars=no,toolbar=no');
    // file_progress_win.focus();
    
    return true;
}


// --------------------------------------------------------------------- FILE_PROGRESS ---------------------------------------------------------------------- //


function progressupdate(boxnum) {
    var progress_end      = 20;
    var progress_interval = 500;
    
    boxnum++;
    if (boxnum > progress_end) {
        for (var i = 1; i <= progress_end; i++) document.getElementById('box' + i).className = 'progress01';
	boxnum = 0;
    }
    else {
        document.getElementById('box' + boxnum).className = 'progress02';
    }
    
    setTimeout('progressupdate(' + boxnum + ')', progress_interval);
}


// -------------------------------------------------------------------- MANAGE_UPLOADS ---------------------------------------------------------------------- //


function checkcreateupload(frm, experiments) {
    var exp_name = frm.elements['experiment_name'].value;
    var errors   = 0;
    var message  = 'The create new upload page has the following errors:\n';
    
    exp_name = clean_whitespace(exp_name);
    
    if (isblank(exp_name)) {
        errors++;
	message += '\n-- Experiment name is required\n';
    } 
    else {
	for (var expid in experiments) {
	    if (experiments[expid].toLowerCase() == exp_name.toLowerCase()) {
	        errors++;
	        message += '\n-- Experiment "' + exp_name + '" already exists\n';
		break;
	    }
	}
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and create the experiment again.\n';
        alert(message);
        return false;
    }
    
    return true;
}


function renameexp(namefield, experiments, expid) {
    var frm = document.getElementById('manage_uploads');
    
    var new_expname = prompt('Please enter a new experiment name for "' + experiments[expid] + '":', experiments[expid]);
    if (new_expname && !isblank(new_expname)) {
        new_expname = clean_whitespace(new_expname);
	
	var nameexists = false;
	for (var id in experiments) {
	    if (experiments[id].toLowerCase() == new_expname.toLowerCase()) {
	        nameexists = true;
		break;
	    }
	}
	
	if (!nameexists) {
	    var newname_hidden = document.getElementById('newname_' + expid);
	    if (newname_hidden) {
	        newname_hidden.value = new_expname;
	    }
	    else {
	        var new_hidden   = document.createElement('input');
		new_hidden.type  = 'hidden';
                new_hidden.name  = 'rename_exps';
                new_hidden.value = expid;
                frm.appendChild(new_hidden);
		
		new_hidden       = document.createElement('input');
		new_hidden.type  = 'hidden';
		new_hidden.id    = 'newname_' + expid;
                new_hidden.name  = 'new_names';
                new_hidden.value = new_expname;
                frm.appendChild(new_hidden);
	    }
	    
	    namefield.innerHTML = new_expname + '*';
	    var remove_check = document.getElementById('remove_' + expid);
	    remove_check.disabled = true;
	}
	else {
	    alert('Experiment "' + new_expname + '" already exists\n');
	    renameexp(namefield, experiments, expid);
	}
    }
    // after user prompt for new experiment name, onmouseout doesn't fire so we fire it here
    // namefield.className = 'expname01over';
}


function checkmanageexps(frm, experiments) {
    var removechecked = false;
    var errors        = 0;
    var removemessage = 'Are you sure you would like to PERMANENTLY DELETE these experiments?\n';
    var message       = 'The manage uploads page has the following errors:\n';
    var rename        = false;
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'checkbox' && frm.elements[i].name == 'remove_exps') {
	    if (frm.elements[i].checked == true) {
	        removechecked  = true;
		removemessage += '\n"' + experiments[frm.elements[i].value] + '"\n';
	    }
	}
	else if (frm.elements[i].name == 'rename_exps') rename = true;
    }
    
    if (!removechecked && !rename) {
        errors++;
	message += '\n-- No experiments are selected to be renamed/removed\n';
    }
     
    if (removechecked && !confirm(removemessage + '\n')) return false;
    
    if (errors > 0) {
        message += '\nPlease make the changes and manage experiments again.\n';
        alert(message);
        return false;
    }
    
    return true;
}


// ---------------------------------------------------------------------- SEARCH_REP ------------------------------------------------------------------------ //


function byorderthenname (a, b) {
    return (a.order !== undefined && b.order !== undefined)
              ? a.order < b.order
	          ? -1
		  : a.order > b.order
		      ? 1
		      : a.text.toLowerCase() < b.text.toLowerCase()
		          ? -1
			  : a.text.toLowerCase() > b.text.toLowerCase()
			      ? 1
			      : 0
              : a.order !== undefined
	          ? -1
		  : b.order !== undefined
		      ? 1
		      : a.text.toLowerCase() < b.text.toLowerCase()
		          ? -1
			  : a.text.toLowerCase() > b.text.toLowerCase()
			      ? 1
			      : 0;
}


function addsearchcriteria(frm, attributes, source_element_name, target_element_name) {
    var sourceselect = frm.elements[source_element_name];
    var targetselect = frm.elements[target_element_name];
    
    for (var i = sourceselect.options.length - 1; i >= 0; i--) {
        if (sourceselect.options[i].selected == true) {
	    var target_option = targetselect.appendChild(sourceselect.options[i]);
	    target_option.selected = false;
	}
    }
    
    // sorting
    var targetoptions = new Array();
    for (var i = 0; i < targetselect.options.length; i++) {
        targetoptions.push(targetselect.options[i]);
    }
    
    targetoptions.sort(ignoringcase);
    
    for (var i = 0; i < targetoptions.length; i++) {
        targetoptions[i].innerHTML = targetoptions[i].text; // internet explorer fix
	targetselect.appendChild(targetoptions[i]);
    }
    
    // deselect any selected elements
    sourceselect.selectedIndex = -1;
    targetselect.selectedIndex = -1;
}


function removesearchcriteria(frm, attributes, source_element_name, target_element_name) {
    var sourceselect = frm.elements[source_element_name];
    var targetselect = frm.elements[target_element_name];
    
    for (var i = sourceselect.options.length - 1; i >= 0; i--) {
        if (sourceselect.options[i].selected == true) {
	    var target_attrs_optgroup = document.getElementById('optgroup_attrs_' + attributes['attr_values_' + sourceselect.options[i].value].group_id);
	    var target_option = target_attrs_optgroup.appendChild(sourceselect.options[i]);
	}
    }
    
    // do sorting
    
    // deselect any selected elements
    sourceselect.selectedIndex = -1;
    targetselect.selectedIndex = -1;
}


function checkselectcriteria(frm) {
    var errors           = 0;
    var message          = 'The select search criteria page has the following errors:\n';
    var selected_attrs   = frm.elements['selected_attr_ids'];
    
    if (selected_attrs.options.length == 0) {
        errors++;
        message += '\n-- No search criteria selected\n';
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and set up your search again.\n';
	alert(message);
	return false;
    }
    
    for (var i = 0; i < selected_attrs.options.length; i++) {
        selected_attrs[i].selected = true;
    }
    
    return true;
}

function checkselectgroups(frm, name) {
}



function checkdatefield(inputelement) {
    if (inputelement.className == 'date01init') inputelement.className = 'date01';
    if (inputelement.value     == 'DD-MM-YYYY') inputelement.value     = '';
}


function checksearchrep(frm, attributes) {
    var errors       = 0;
    var message      = 'The search repository page has the following errors:\n';
    var dateschecked = new Object();
    
    for (var i = 0; i < frm.elements.length; i++) {
        // check value fields
	if (attributes[frm.elements[i].name]) {
	    var field_name = attributes[frm.elements[i].name].name;
	    if (attributes[frm.elements[i].name].is_date) {
	        if (!dateschecked[frm.elements[i].name]) {
		    // need to do this for text box array to work
		    var date = frm.elements[frm.elements[i].name];
		    
		    // clean up date fields (from & to)
		    for (var j = 0; j < date.length; j++) {
		        var field_type = j == 0 ? 'From' :
		                         j == 1 ? 'To'   : '';
		        
		        date[j].value = clean_whitespace(date[j].value);
		        if (date[j].value == 'DD-MM-YYYY') date[j].value = '';
		        
		        var date_fields = date[j].value.match(/^(\d{2})-(\d{2})-(\d{4})$/);
		        if (date_fields) {
		            var last_days = { '01': 31, '02': 28, '03': 31, '04': 30, '05': 31, '06': 30, '07': 31, '08': 31, '09': 30, '10': 31, '11': 30, '12': 31 };
		            
		            var day   = date_fields[1];
		            var month = date_fields[2];
		            var year  = date_fields[3];
		            
		            if (month in last_days) {
		                if (day < 1 || day > last_days[month]) {
			            errors++;
			            message += '\n-- The attribute "' + field_name + ' ' + field_type + '" has the day not in the appropriate range 01-' + last_days[month] + '\n';
			        }
		            }
		            else {
		                errors++;
			        message += '\n-- The attribute "' + field_name + ' ' + field_type + '" has the month not in the appropriate range 01-12\n';
		            }
                        }
		        // bad date format
		        else if (!isblank(date[j].value)) {
		            errors++;
		            message += '\n-- The attribute "' + field_name + ' ' + field_type + '" does not have the date format DD-MM-YYYY\n';
		        }
		    }
		    
		    // blank date fields from & to
                    if (isblank(date[0].value) && isblank(date[1].value)) {
                        errors++;
                        message += '\n-- The attribute "' + field_name + '" is blank\n';
                    }
		
		    dateschecked[frm.elements[i].name] = 1;
		}
	    }
	    // check all regular attribute fields
	    else if (frm.elements[i].type == 'text' || frm.elements[i].type == 'textarea') {
	        frm.elements[i].value = clean_whitespace(frm.elements[i].value);
		if (isblank(frm.elements[i].value)) {
		    errors++;
	            message += '\n-- The attribute "' + field_name + '" is blank\n';
		}
		else if (attributes[frm.elements[i].name].is_numeric && !checknumber(frm.elements[i])) {
		    errors++;
		    message += '\n-- The attribute "' + field_name + '" needs to be numeric\n';
		}
	    }
	    else if ((frm.elements[i].type == 'select-one'      && frm.elements[i].selectedIndex ==  0) || 
	             (frm.elements[i].type == 'select-multiple' && frm.elements[i].options.length == 0)) {
	        errors++;
		message += '\n-- The attribute "' + field_name + '" has no selections\n';
	    }
	}
	// check units fields
	else if (frm.elements[i].name.search(/^attr_units_\d+$/i) != -1) {
	    var units_field  = frm.elements[i].name.match(/^attr_units_(\d+)$/i);
	    if (isblank(frm.elements[i].value)) {
	        errors++;
	        message += '\n-- The field "' + attributes['attr_values_' + units_field[1]].name + '" needs units\n';
	    }
	}
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and submit your search again.\n';
	alert(message);
	return false;
    }
    
    // select options in select-multiple elements
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'select-multiple' && attributes[frm.elements[i].name]) {
            for (var j = 0; j < frm.elements[i].options.length; j++) {
                frm.elements[i].options[j].selected = true;
	    }
	}
    }
    
    return true;
}


// -------------------------------------------------------------------- SEARCH_RESULTS ---------------------------------------------------------------------- //


function checkuncheck(checkelement) {
    var frm = checkelement.form
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'checkbox') frm.elements[i].checked = checkelement.checked;
    }
}


function checkdownloadrequest(frm) {
    var errors     = 0;
    var message    = 'The search results download page has the following errors:\n';
    var onechecked = false;
    
    for (var i = 0; i < frm.elements.length; i++) {
        if (frm.elements[i].type == 'checkbox' && frm.elements[i].checked == true) {
	    onechecked = true;
	    break;
	}
    }
    
    if (!onechecked) {
        errors++;
	message += '\n-- No samples are selected to be downloaded\n';
    }
    
    if (errors > 0) {
        message += '\nPlease make the changes and submit your download request again.\n';
	alert(message);
	return false;
    }
    
    return true;
}

function setAttrDescription(targetid, obj) {
    var magename = obj.options[obj.selectedIndex].getAttribute("_mimas_mage_name") || "";
    var desc = document.getElementById(targetid);
    if (desc) {
        desc.value = mged_desc[magename] || "";
    }
    else {
        //ok, textarea does not exist if no mage_name
    }
}


//]]> End script hiding -->

