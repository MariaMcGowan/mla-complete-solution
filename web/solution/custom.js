/*******************************************************************************
Solution-specific JavaScript goes in this file.
*******************************************************************************/

/*******************************************************************************
documentOnReadyCustom() - This function is called when the document is ready to
                          be processed by JavaScript.
*******************************************************************************/
var websiteColor = 'green';
var websiteSecondaryColor = 'blue';
var EggsPerIncubatorCart = 4608;
var EggsPerDeliveryCart = 4320;
var EggsPerShelf = 144;
var EggsPerIncubatorShelf = 144;
var EggsPerDeliveryShelf = 1080;
var EggsPerTray = 36;
var EggsPerCase = 360;
var EggsPerColumn = 2304;


function formLoadReady(screenID, form) {
   
}

function listLoadReady(screenID) {
	switch (screenID) {
		case "PulletPlan_List":
			//setFixedTop('table');
			break;
		case "FlockRotation_List":
      FlockRotationListOnLoad();
      break;
	}
}

      ////////////////////////////////////////////////////////////////////
     //                 Page On Load Functions                         //
    ////////////////////////////////////////////////////////////////////

function FlockRotationListOnLoad ()
{
    var i;
    for (i = 1; i < 30; i++) {
      strColumnNbr = '00' + i.toString();
      controlID = "#Date" + strColumnNbr.slice(strColumnNbr.length - 2, strColumnNbr.length);
      $(controlID).val('');	
    }
}

function listTemplateDataLoaded(data, screenID) {
	switch (screenID) {
		case "ProjectedOrderList":
			//we need to trick the screen into thinking these have all been changed
			for (i = 0; i < data.records.length; i++) {
				if (data.records[i].ProjectedOrderID == '0') {
					data.records[i].Selected = true;
					data.records[i].thisRowHasChanged = true;
				}
			}
			break;
		case "PADLSReportScreen":
			$.ajax({
				type: 'POST',
				url: 'DataLoad/DataLoad.aspx?screenID=PADLSColumnDef',
				dataType: 'json',
				success: function (results, status) {
				data.setAdvancedSearchFields(results);
				},
				error: function () {
					alert('There was an error.');
				}
			});
			
			break;
			
	}
}

function CommercialDetail_Select(thisRecord) {

	if (thisRecord.ReservedQty_InCases > 0) {
		thisRecord.Selected = '1';
	}

	return true;

}

function CommercialDetail_SelectAllorNone(thisRecord) {
	if (thisRecord.Selected == '1' && newValue.ReservedQty_InCases == '0') {
		thisRecord.ReservedQty_InCases = thisRecord.AvailableQty_InCases;
	}
	else
	{
			thisRecord.ReservedQty_InCases = 0;
	}

	return true;

}

function menuReady() {
    
}

function leftMenuReady() {
    //alert('hey');
    //$('<img id="KFLogo" src="solution/images/KDFlogo-80yrs.png" class="hidden-xs bottom-link" style="max-width:100%;padding:0px 10px;" />')
    //    .insertAfter($('#cssleftmenu .bottom-link:last'))
    //    .load(function () { respaceLeftNav(); respaceLeftNav(); });
    moveLeftNav();
    //respaceLeftNav();
}

function DateAdd(thisRecord, origDateFieldName, newDateFieldName, addDayCount) {

	var date = new Date(thisRecord[origDateFieldName]);
	dd = date.getDate();
	mm = date.getMonth();
	yyyy = date.getFullYear();

	var addDays = 0;

	addDays = parseInt(addDayCount);
	var newDate = new Date(yyyy, mm, dd + addDays);
	
	thisRecord[newDateFieldName] = (newDate.getMonth() + 1) + '/' +  newDate.getDate() + '/' + newDate.getFullYear();

	return true;
}

function CalcReserved(thisRecord, detailRecords, record) {

	thisRecord.ReserveQty_InCases = thisRecord.ReserveQtyPerDay_InCases * 7;

	if (thisRecord.ReserveQtyPerDay_InCases > 0) {
		thisRecord.Selected = '1';
	}

	var total = 0;
	var reserveCases = 0;


	for (var i = 0; i < detailRecords[0].CommercialCommitment_SelectDetail_EggWgt01.length; i++) {

		reserveCases = detailRecords[0].CommercialCommitment_SelectDetail_EggWgt01[i].ReserveQty_InCases;
		if (reserveCases) {
			total = total + parseInt(reserveCases);
		}
	}

	reserveCases = 0;
	for (var i = 0; i < detailRecords[0].CommercialCommitment_SelectDetail_EggWgt02.length; i++) {

		reserveCases = detailRecords[0].CommercialCommitment_SelectDetail_EggWgt02[i].ReserveQty_InCases;
		if (reserveCases) {
			total = total + parseInt(reserveCases);
		}
	}

	reserveCases = 0;
	for (var i = 0; i < detailRecords[0].CommercialCommitment_SelectDetail_EggWgt03.length; i++) {

		reserveCases = detailRecords[0].CommercialCommitment_SelectDetail_EggWgt03[i].ReserveQty_InCases;
		if (reserveCases) {
			total = total + parseInt(reserveCases);
		}
	}

	reserveCases = 0;
	for (var i = 0; i < detailRecords[0].CommercialCommitment_SelectDetail_EggWgt04.length; i++) {

		reserveCases = detailRecords[0].CommercialCommitment_SelectDetail_EggWgt04[i].ReserveQty_InCases;
		if (reserveCases) {
			total = total + parseInt(reserveCases);
		}
	}

	console.log(total);
	record.ReservedQty_InCases = total.toString();
	return true;
}

function PredictEggs_ChangeExpectedYield(detailRecords, thisRecord, fieldName) {

	thisRecord.thisRowHasChanged = true;
	return true;
}

function customFormDataChange(thisRecord) {

	thisRecord.thisRowHasChanged = true;
	return true;
}

function projectedOrders_Load(thisRecord) {

	if (thisRecord.ProjectedOrderID == 0) {
		thisRecord.thisRowHasChanged = true;
	}
	return true;
}

function documentOnReadyCustom(screenID, form) {
    
    initializeResizeListener();
    
    if ($("link[href='css/lsNoHeaderNoMenu.css']").length) {
        $('#mainContentContainer').removeClass('col-sm-10').removeClass('col-sm-offset-2');
    }

    $('#menuBar').prepend('<ul id="favorite" class = "nav navbar-nav sm sm-simple favorite"><a href="javascript:void(0)" onclick="addToFavorites();"><img src="images/BookmarkAdd.png" style="width:15px;"/></a></ul>');

    switch (screenID) {
	    

        case "ScreenSecurity":
          
            break;
	}


}

var waitForFinalEvent = function () { var b = {}; return function (c, d, a) { a || (a = "I am a banana!"); b[a] && clearTimeout(b[a]); b[a] = setTimeout(c, d) } }();
function initializeResizeListener() {
    $(window).resize(function () {
        waitForFinalEvent(moveLeftNav, 100, new Date().getTime());
        respaceLeftNav();
    });
}


function allowDrop(ev) {
	ev.preventDefault();
}

var sourceFarmID;
var sourceContractTypeID;

function drag(ev) {

	var img = new Image();

	//var img = document.createElement("img");
	img.src = "/MLA/images/plus.png";
	ev.dataTransfer.setDragImage(img, 10, 10);
	
	ev.dataTransfer.setData("PulletFarmPlanID", ev.target.getAttribute("PulletFarmPlanID"));
	ev.dataTransfer.setData("WeekEndingDate", ev.target.getAttribute("WeekEndingDate"));
//	ev.dataTransfer.setData("DraggableValue", ev.target.getAttribute("DraggableValue"));
//	ev.dataTransfer.setData("FlockID", ev.target.getAttribute("FlockID"));
	ev.dataTransfer.setData("FarmID", ev.target.getAttribute("FarmID"));
	ev.dataTransfer.setData("ContractTypeID", ev.target.getAttribute("ContractTypeID"));
	sourceFarmID = ev.target.getAttribute("FarmID");
	sourceContractTypeID = ev.target.getAttribute("ContractTypeID");

}

function drop(ev) {
	ev.preventDefault();

	// User can only drag the first flock date or the last flock date
	//var origFlockWeekNumber = ev.dataTransfer.getData("flockWeekNumber");
	//var origFlockWeekCount = ev.dataTransfer.getData("flockWeekCount");

	// If this is a new planned flock, then the user is dragging the first flock date
	//if (origPulletFarmPlanID == 0) {
	//	origFlockWeekNumber = 1;
	//	origFlockWeekCount = 41;
	//}

	var origPulletFarmPlanID = ev.dataTransfer.getData("PulletFarmPlanID");
	var origWeekEndingDate = ev.dataTransfer.getData("WeekEndingDate");
	var origFarmID = ev.dataTransfer.getData("FarmID");
	var origContractTypeID = ev.dataTransfer.getData("ContractTypeID");

	var targetPulletFarmPlanID = ev.target.getAttribute("PulletFarmPlanID");
	var targetWeekEndingDate = ev.target.getAttribute("WeekEndingDate");
	var targetFarmID = ev.target.getAttribute("FarmID");


	//var targetFlockWeekNumber = ev.target.getAttribute("flockWeekNumber");

	//var params = '&p=' + origPulletFarmPlanID + '&p=' + origFarmID + '&p=' + origWeekEndingDate + '&p=' + targetWeekEndingDate;
	var params = '&p=' + origPulletFarmPlanID + '&p=' + origFarmID + '&p=' + origWeekEndingDate + '&p=' + targetWeekEndingDate + '&p=' + origContractTypeID;

	if (origFarmID == targetFarmID) {
		showInDialog('runProcess.aspx?screenID=FlockRotation_DragDrop' + params, 'Flock Planning', 760, 700);
	} else {
		//alert('cannot drag between different columns');
	}

}

function dragEnter(ev) {
	//var className = '';
	//// User can only drag the first flock date or the last flock date
	//var flockWeekNumber = ev.dataTransfer.getData("flockWeekNumber");

	//// If this is a new planned flock, then the user is dragging the first flock date
	//if (origPulletFarmPlanID == 0) {
	//	flockWeekNumber = 1;
	//}

	// We can do some highlighting for new planned flocks
	//if (flockWeekNumber == 1) {
			//var prevDif = parseInt(ev.target.getAttribute("WeeksSinceLastFlock"));
	//var nextDif = parseInt(ev.target.getAttribute("WeeksBeforeNextFlock"));
	////var origFarmID = ev.dataTransfer.getData("FarmID");
	//var origFarmID = sourceFarmID;
	//var targetFarmID = ev.target.getAttribute("FarmID");

		//if (origFarmID == targetFarmID) {

	//	if (draggableValue == 'EndDate') {
	//		// Reset the 
	//	}
	//	console.log('Previous' + prevDif);
	//	console.log('Next' + nextDif);

	//	if (prevDif > 0 && prevDif < 10 && nextDif > 0) {
	//		//next dif is valid, prev dif is valid but in warning zone
	//		className = 'redBox';
	//	}
	//	if (prevDif > 0 && nextDif > 0 && nextDif < 10) {
	//		//prev dif is valid, next dif is valid but in warning zone
	//		className = 'redBox';
	//	}
	//	if (prevDif > 10 && nextDif > 10) {
	//		//both dif are valid and not in warning zone
	//		className = 'blueBox';
	//	}

	//	if (className > '') {
	//		if (ev.target.type == 'DIV') {
	//			$(ev.target).parent().addClass(className);
	//		} else {
	//			$(ev.target).addClass(className);
	//		}
	//	}
	//}
	//}

	
}



function dragLeave(ev) {
	if (ev.target.type == 'DIV') {
		$(ev.target).parent().removeClass('redBox');
		$(ev.target).parent().removeClass('blueBox');
	} else {
		$(ev.target).removeClass('redBox');
		$(ev.target).removeClass('blueBox');
	}
}

function weightConversion(thisRecord) {
    thisRecord.Wgt_PostCon = roundToDecimal(thisRecord.WgtPreCon * 16 / 30, 1);

    if (thisRecord.Wgt_PostCon != 0 && (thisRecord.Wgt_PostCon < 22 || thisRecord.Wgt_PostCon > 32)) {
        thisRecord.candleoutWeightClass = 'candleoutWeightDifference';
    }
    else {
        thisRecord.candleoutWeightClass = '';
    }

    return true;
}


function defaultIncubatorCartQuantity(detailRecords, thisRecord) {
    thisRecord.ActualQty = 4608;
    thisRecord.thisRowHasChanged = true;

    IncubatorLoad_Recalc(detailRecords, thisRecord);

    return true;
}
function defaultHoldingIncubatorCartQuantity(thisRecord, fieldName) {

    if (fieldName == 'FlockID2') {
        thisRecord.ActualQty2 = 4320 - parseInt(thisRecord.ActualQty1);
        thisRecord.Carts2 = '';
        thisRecord.Shelves2 = Math.floor(thisRecord.ActualQty2 / EggsPerDeliveryShelf);
        thisRecord.Trays2 = Math.floor((thisRecord.ActualQty2 % EggsPerDeliveryShelf) / EggsPerTray);
        thisRecord.Eggs2 = thisRecord.ActualQty2 % EggsPerTray;
    } else {
        thisRecord.ActualQty1 = 4320;
        thisRecord.Carts1 = 1;
        thisRecord.Shelves1 = '';
        thisRecord.Trays1 = '';
        thisRecord.Eggs1 = '';

        thisRecord.LoadDate = getCurrentDateTime('date');
        thisRecord.LoadTime = getCurrentDateTime('time');
    }
    if (thisRecord.ActualQty1 != EggsPerDeliveryCart && parseInt(thisRecord.ActualQty1) + parseInt(thisRecord.ActualQty2) != EggsPerDeliveryCart && parseInt(thisRecord.ActualQty1) != 0) {
        thisRecord.className = 'yellowBackground';
    } else {
        thisRecord.className = '';
    }
    thisRecord.thisRowHasChanged = true;
    return true;
}

/********************************************
    changes by MCM 
    *********************************************/

function GetClutchID(detailRecords, FlockID, LayDate) {

    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];

        if (currentRow.FlockID == FlockID && currentRow.LayDate == LayDate)  {
            return currentRow.ClutchID;
        }
    }

    return 0;

}


function GetIncubator_ClutchQuantity(detailRecords, ClutchID) {
   
	
    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];
		
        if (currentRow.ClutchID == ClutchID) {
			return currentRow.IncubatorQty;
        }
    }
	
    
	return Qty;
	
}

function SetIncubator_ClutchQuantity (detailRecords, ClutchID, Quantity){
  
    var Remaining = Quantity;

    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];
		
        if (currentRow.ClutchID == ClutchID) {
            currentRow.IncubatorQty = Quantity;
            
            currentRow.IncubatorQtyRacks = Remaining / EggsPerIncubatorCart;
            Remaining = Remaining - (currentRow.IncubatorQtyRacks * EggsPerIncubatorCart);

            currentRow.IncubatorQtyColumns = Remaining / EggsPerColumn;
            Remaining = Remaining - (currentRow.IncubatorQtyColumns * EggsPerColumn);

            currentRow.IncubatorQtyShelves = Remaining / EggsPerIncubatorShelf;
            Remaining = Remaining - (currentRow.IncubatorQtyShelves * EggsPerIncubatorShelf);

            currentRow.IncubatorQtyEggs = Remaining;
        }
    }
	
	return true;
	
}

function GetCooler_ClutchQuantity (detailRecords, ClutchID){
    var Qty = 0;
    	
    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];
		
        if (currentRow.ClutchID == ClutchID) {
			Qty = currentRow.CoolerQty;
        }
    }
	
	return Qty;
}


function SetCooler_ClutchQuantity (detailRecords, ClutchID, Quantity){
    var Remaining = Quantity;

    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];
		
        if (currentRow.ClutchID == ClutchID) {
            currentRow.CoolerQty = Quantity;

            currentRow.CoolerQtyRacks = Remaining / EggsPerIncubatorCart;
            Remaining = Remaining - (currentRow.CoolerQtyRacks * EggsPerIncubatorCart);

            currentRow.CoolerQtyColumns = Remaining / EggsPerColumn;
            Remaining = Remaining - (currentRow.CoolerQtyColumns * EggsPerColumn);

            currentRow.CoolerQtyShelves = Remaining / EggsPerIncubatorShelf;
            Remaining = Remaining - (currentRow.CoolerQtyShelves * EggsPerIncubatorShelf);

            currentRow.CoolerQtyEggs = Remaining;
        }
    }
	
	return true;
}

function IncubatorLoad_SetClassNameField(thisRecord, detailRecords, clutchID, className) {

    if (!clutchID || clutchID == 0) {
        // The clutch is empty!
		thisRecord.className = 'InvalidClutchQty';
		//thisRecord.ErrorMessage = 'WARNING - The cooler does not contain these eggs!';
    }
    else {

        for (var i = 0; i < detailRecords[0].IncubatorLoad_Details.length; i++) {
            var currentRow = detailRecords[0].IncubatorLoad_Details[i];

            if (currentRow.ClutchID == clutchID) {
                currentRow.className = className;

                //if (className == 'InvalidClutchQty') {
                //    currentRow.ErrorMessage = 'WARNING - The cooler does not have enough eggs to do this transaction!';
                //}
                //else {
                //    currentRow.ErrorMessage = '';
                //}
            }
        }
    }
    return true;
}

function IncubatorLoad_RecalcClassNames(thisRecord,detailRecords) {
    
    var className = '';

    for (var i = 0; i < detailRecords[0].IncubatorLoad_CoolerClutch.length; i++) {
        var currentRow = detailRecords[0].IncubatorLoad_CoolerClutch[i];

        var clutchID = currentRow.ClutchID;

        if (!clutchID || clutchID == 0) {
            // Invalid ClutchID
            // Considering that the user can only choose flocks that are in the Load Plan
            // This means that the chosen lay date is not in the system, and therefore not in the cooler!

			IncubatorLoad_SetClassNameField(thisRecord, detailRecords, clutchID, InvalidClutchQty);

        }
        else {

            if (currentRow.CoolerQty < 0) {
                className = 'InvalidClutchQty';
                IncubatorLoad_SetClassNameField(thisRecord, detailRecords, clutchID, className);
            }
        }

    }


    return true;
}


function IncubatorLoad_Recalc(detailRecords, thisRecord) {
    //alert('IncubatorLoad_Recalc');

    var unknownClutchID = 0;
    var qtyErrorClutchID = 0;
    var orderIncubatorCartID = thisRecord.OrderIncubatorCartID;
    var orig_FlockID = thisRecord.orig_FlockID;
    var orig_LayDate = thisRecord.orig_LayDate;
    var orig_CartClutchID = thisRecord.Orig_ClutchID;
    var orig_CartQuantity = thisRecord.Orig_ActualQty;
    
    var new_FlockID = thisRecord.FlockID;
    var new_LayDate = thisRecord.LayDate;
    var new_CartClutchID = thisRecord.ClutchID;
    var new_CartQuantity = thisRecord.ActualQty;

    var orig_ClassName = thisRecord.Orig_className;
    

    // What changed?  
    // Flock?
    if (orig_FlockID != new_FlockID) {
        //alert('0')
        new_CartClutchID = GetClutchID(detailRecords, new_FlockID, new_LayDate);
        thisRecord.ClutchID = new_CartClutchID;
    }


    //  If the orderIncubatorCartID is null, then it is a new value
	// Otherwise, update the information

    //alert('1');

    if (parseInt(orderIncubatorCartID) > 0) {
        var CoolerQuantity_OrigClutch = GetCooler_ClutchQuantity(detailRecords, orig_CartClutchID);
        var IncubatorQuantity_OrigClutch = GetIncubator_ClutchQuantity(detailRecords, orig_CartClutchID);


        //alert('2');

        // If the new clutchid is null
        if (!new_CartClutchID || new_CartClutchID == 0) {
            
            //alert('3');
            // Invalid ClutchID
            // Considering that the user can only choose flocks that are in the Load Plan
            // This means that the chosen lay date is not in the system, and therefore not in the cooler!

			IncubatorLoad_SetClassNameField(thisRecord, detailRecords, new_CartClutchID, 'InvalidClutchQty');
 
            // Add these eggs back into the cooler quantities 
            SetCooler_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(CoolerQuantity_OrigClutch) + parseInt(orig_CartQuantity));

            // Take these eggs out of the incubator  
            SetIncubator_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(IncubatorQuantity_OrigClutch) - parseInt(orig_CartQuantity));

            // What is the current quantity in the cooler for this 

            var CoolerQuantity = GetCooler_ClutchQuantity(detailRecords, orig_CartClutchID);
            if (parseInt(CoolerQuantity) < 0) {
                //alert('3 - error');
                qtyErrorClutchID = orig_CartClutchID;
            }

            thisRecord.Orig_ClutchID = 0;
            thisRecord.Orig_ActualQty = 0;

        }
        else {

            //alert('4');

            // did someone change the clutch for the cart? 
			//   if so, give the cooler qty back to the original clutch
			//   and take it away from the new clutch

            if (new_CartClutchID != orig_CartClutchID) {

                //alert('5');

                // Undo the original 

                // Put the original quantity of the original clutch back in the cooler (positive qty) 
                SetCooler_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(CoolerQuantity_OrigClutch) + parseInt(orig_CartQuantity));

                // Take this original quantity from the original clutch, and take it out of the incubator 
                SetIncubator_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(IncubatorQuantity_OrigClutch) - parseInt(orig_CartQuantity));

                // Process the new one 

                // Now take the entire amount of the cooler out from the new flock 
                var CoolerQuantity_NewClutch = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);
                SetCooler_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(CoolerQuantity_NewClutch) - parseInt(orig_CartQuantity));

                // Put the entire amount of for this new clutch into the incubator 
                var IncubatorQuantity_NewClutch = GetIncubator_ClutchQuantity(detailRecords, new_CartClutchID);
                SetIncubator_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(IncubatorQuantity_NewClutch) + parseInt(orig_CartQuantity));

                var CoolerQuantity = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);
                if (parseInt(CoolerQuantity) < 0) {
                    qtyErrorClutchID = new_CartClutchID;
                }

                thisRecord.Orig_ClutchID = new_CartClutchID;
                thisRecord.Orig_ActualQty = new_CartQuantity;

            }
            else {

                //alert('6');

                // So the clutch is the same, is the quantity the same?
                if (parseInt(new_CartQuantity) != parseInt(orig_CartQuantity)) {
                    //alert('7');

                    // Put the original quantity of the original clutch back in the cooler (positive qty)
                    SetCooler_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(CoolerQuantity_OrigClutch) + parseInt(orig_CartQuantity));

                    // Take this original quantity from the original clutch, and take it out of the incubator 
                    SetIncubator_ClutchQuantity(detailRecords, orig_CartClutchID, parseInt(IncubatorQuantity_OrigClutch) - parseInt(orig_CartQuantity));

                    // Process the new one

                    // Now take the entire amount of the cooler out from the new flock 
                    var CoolerQuantity_NewClutch = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);

                    SetCooler_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(CoolerQuantity_NewClutch) - parseInt(new_CartQuantity));

                    // Put the entire amount of for this new clutch into the incubator 
                    var IncubatorQuantity_NewClutch = GetIncubator_ClutchQuantity(detailRecords, new_CartClutchID);
                    SetIncubator_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(IncubatorQuantity_NewClutch) + parseInt(new_CartQuantity));

                    var CoolerQuantity = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);
                    if (parseInt(CoolerQuantity) < 0) {
                        qtyErrorClutchID = new_CartClutchID;
                    }

                    thisRecord.Orig_ActualQty = new_CartQuantity;
                }
            }
        }
    }
    else {

        //alert('8');
        // this is not an existing order incubator cart, so, there isn't any clutches to change 
        var new_FlockID = thisRecord.FlockID;
        var new_LayDate = thisRecord.LayDate;

        new_CartClutchID = GetClutchID(detailRecords, new_FlockID, new_LayDate);

        if (parseInt(new_CartClutchID) > 0) {

            // Process the new one 
            //alert('New Clutch ID');
            //alert(new_CartClutchID);


            // Now take the entire amount of the cooler out from the new flock 
            var CoolerQuantity_NewClutch = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);

            SetCooler_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(CoolerQuantity_NewClutch) - parseInt(new_CartQuantity));

            // Put the entire amount of for this new clutch into the incubator 
            var IncubatorQuantity_NewClutch = GetIncubator_ClutchQuantity(detailRecords, new_CartClutchID);

            SetIncubator_ClutchQuantity(detailRecords, new_CartClutchID, parseInt(IncubatorQuantity_NewClutch) + parseInt(new_CartQuantity));

            var CoolerQuantity = GetCooler_ClutchQuantity(detailRecords, new_CartClutchID);
            if (parseInt(CoolerQuantity) < 0) {
                qtyErrorClutchID = new_CartClutchID;
            }
            thisRecord.Orig_ClutchID = new_CartClutchID;
            thisRecord.Orig_ActualQty = new_CartQuantity;
        }
        else {
            //alert('Trigger Error!');
            unknownClutchID = 1;

            thisRecord.Orig_ClutchID = 0;
            thisRecord.Orig_ActualQty = 0;
        }
    }

    if (parseInt(unknownClutchID) > 0) {

            //alert('WARNING - The chosen eggs are not in the Load Plan!');
			IncubatorLoad_SetClassNameField(thisRecord, detailRecords, qtyErrorClutchID, 'NotInLoadPlan');
    }
    else {
        if (parseInt(qtyErrorClutchID) > 0) {
            // Find all records with this clutchid and change their class to invalid clutch qty

            //alert('WARNING - The cooler does not have enough eggs to do this transaction!');
            IncubatorLoad_SetClassNameField(thisRecord, detailRecords, qtyErrorClutchID, 'InvalidClutchQty');
        }
        else {

            //if (thisRecord.ActualQty != 0 && thisRecord.ActualQty != EggsPerIncubatorCart && parseInt(thisRecord.ActualQty) != 0) {
            //    IncubatorLoad_SetClassNameField(thisRecord, detailRecords, qtyErrorClutchID, 'yellowBackground');
            //} else {

                IncubatorLoad_SetClassNameField(thisRecord, detailRecords, thisRecord.ClutchID, orig_ClassName);
            //}

            //IncubatorLoad_SetClassNameField(thisRecord, detailRecords, thisRecord.ClutchID, orig_ClassName);
			//IncubatorLoad_SetClassNameField(thisRecord, detailRecords, thisRecord.ClutchID, '');
        }
    }

    IncubatorLoad_RecalcClassNames(thisRecord,detailRecords);

    thisRecord.thisRowHasChanged = true;
    return true;
}

/********************************************
    changes by MCM 
    *********************************************/

function DefaultCustomIncubation(detailRecords, thisRecord) {

	if (thisRecord.IncubationDayCnt != 11) {
		thisRecord.CustomIncubation = '1';
	}
	else {
		thisRecord.CustomIncubation = '0';
	}

	return true;
}

function LoadPlanningRecalc(detailRecords, thisRecord) {
    var overflowFlockArray = $.grep(detailRecords[0].LoadPlanning_Detail, function (element, index) {
        return element.IsOverflow == "1";
    });
    LoadPlanningQty(overflowFlockArray[0], detailRecords, thisRecord);
    return true;
}

function LoadPlanningQty(thisRecord, detailRecords, record) {
	var overflowFlockArray = $.grep(detailRecords[0].LoadPlanning_Detail, function (element, index) {
		return element.IsOverflow == "1";
	});
	var totalArray = $.grep(detailRecords[0].LoadPlanning_Detail, function (element, index) {
		return element.LoadPlanning_DetailID == "-1";
	});
	var isOverflowFlockArray = thisRecord.FlockID == overflowFlockArray[0].FlockID;

	if (!isOverflowFlockArray) {
		convertEggQty(thisRecord, 'FlockIncubatorCartQty', 'FlockQty', 'incubatorCart', 'egg');
		setProjectedOutcome(thisRecord);
	}

	var totalQty = 0;
	var totalProjectedQty = 0;
	for (var i = 0; i < detailRecords[0].LoadPlanning_Detail.length; i++) {
		var currentRow = detailRecords[0].LoadPlanning_Detail[i];
		if (currentRow.FlockID != overflowFlockArray[0].FlockID && typeof (currentRow.FlockQty) !== 'undefined') {
			if (currentRow.FlockQty > '' && currentRow.LoadPlanning_DetailID != '-1') {
				totalQty = totalQty + currentRow.FlockQty;
				if (currentRow.LastCandleoutPercent > '') {
					totalProjectedQty = totalProjectedQty + currentRow.ProjectedOutcome;
				}
			}
		}
	}
	overflowFlockArray[0].FlockQty = roundToDecimal(((record.TargetQty / (1 - (record.PercentCushion / 100)) - totalProjectedQty) / (overflowFlockArray[0].LastCandleoutPercent / 100)) / 144, 0) * 144;
	convertEggQty(overflowFlockArray[0], 'FlockQty', 'FlockIncubatorCartQty', 'egg', 'incubatorCart');

	setProjectedOutcome(overflowFlockArray[0]);

	totalArray[0].FlockQty = totalQty + overflowFlockArray[0].FlockQty;
	totalArray[0].ProjectedOutcome = totalProjectedQty + overflowFlockArray[0].ProjectedOutcome;
	convertEggQty(totalArray[0], 'FlockQty', 'FlockIncubatorCartQty', 'egg', 'incubatorCart');
	convertEggQty(totalArray[0], 'ProjectedOutcome', 'ProjectedOutcomeDeliveryCarts', 'egg', 'deliveryCart');
	totalArray[0].LastCandleoutPercent = roundToDecimal(100 * (totalArray[0].ProjectedOutcome / totalArray[0].FlockQty), 2);

	return true;
}

function setScheduleDate(thisRecord, record) {

	var HatchDate = new Date(thisRecord.HatchDate);
	var DayCount = parseInt(thisRecord.AgeInDays);
	var ScheduleDate = new Date(add_days(HatchDate, DayCount));

	thisRecord.ScheduleDate = getFormattedDate(ScheduleDate);

    return true;
}

function calcPlannedMaleOrder(thisRecord) {

	var PlannedMaleOrder = Math.ceil(Math.ceil(parseInt(thisRecord.PulletQtyAt16Weeks) * parseFloat(thisRecord.ExpectedLivabilityRatio)) * parseFloat(thisRecord.MaleToFemaleBirdRatio));
	thisRecord.PlannedMaleOrderQty = PlannedMaleOrder;

	return true;
}

function calcPulletQtyAt16Wks(thisRecord) {

	var PlannedMaleOrder = parseInt(thisRecord.PlannedMaleOrderQty);
	var LiveabilityRatio = parseFloat(thisRecord.ExpectedLivabilityRatio);
	var MaleToFemaleRatio = parseFloat(thisRecord.MaleToFemaleBirdRatio);
	var PulletQty = Math.ceil(Math.ceil(PlannedMaleOrder / LiveabilityRatio) / MaleToFemaleRatio);

	thisRecord.PulletQtyAt16Weeks = PulletQty;

	return true;
}

function getFormattedDate(date) {
	var year = date.getFullYear();

	var month = (1 + date.getMonth()).toString();
	month = month.length > 1 ? month : '0' + month;

	var day = date.getDate().toString();
	day = day.length > 1 ? day : '0' + day;

	return month + '/' + day + '/' + year;
}

function setProjectedOutcome(thisRecord) {
    thisRecord.ProjectedOutcome = roundToDecimal(thisRecord.FlockQty * (thisRecord.LastCandleoutPercent / 100), 0);
    convertEggQty(thisRecord, 'ProjectedOutcome', 'ProjectedOutcomeDeliveryCarts', 'egg', 'deliveryCart',1);
}

function convertEggQtyTwoFields(thisRecord, fromFieldName, toFieldName, toFieldName2, fromType, toType, toType2, roundDecimal) {

    convertEggQty(thisRecord, fromFieldName, toFieldName, fromType, toType, roundDecimal);
    convertEggQty(thisRecord, fromFieldName, toFieldName2, fromType, toType2, roundDecimal);

    return true;
}

function convertEggQty(thisRecord, fromFieldName, toFieldName, fromType, toType, roundDecimal) {
    var roundDecimal = roundDecimal || 2;

    if (fromType == 'incubatorCart') {
        if (toType == 'egg') {
            thisRecord[toFieldName] = EggsPerIncubatorCart * thisRecord[fromFieldName];
        }
       if (toType == 'case') {
            thisRecord[toFieldName] = EggsPerIncubatorCart * thisRecord[fromFieldName] / EggsPerCase;
        }

    }
    if (fromType == 'deliveryCart') {
        if (toType == 'egg') {
            thisRecord[toFieldName] = EggsPerDeliveryCart * thisRecord[fromFieldName];
        }
    }

    if (fromType == 'case') {
        if (toType == 'egg') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] * EggsPerCase;
        }
        if (toType == 'incubatorCart') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] * EggsPerCase / EggsPerIncubatorCart;
        }
    }
    if (fromType == 'incubatorShelf') {
        thisRecord[toFieldName] = thisRecord[fromFieldName] * EggsPerIncubatorShelf;
    }
    if (fromType == 'tray') {
        thisRecord[toFieldName] = thisRecord[fromFieldName] * EggsPerTray;
    }
    if (fromType == 'egg') {
        if (toType == 'incubatorCart') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] / EggsPerIncubatorCart;
        }
        if (toType == 'deliveryCart') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] / EggsPerDeliveryCart;
        }
        if (toType == 'case') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] / EggsPerCase;
        }
        if (toType == 'incubatorShelf') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] / EggsPerIncubatorShelf;
        }
        if (toType == 'tray') {
            thisRecord[toFieldName] = thisRecord[fromFieldName] / EggsPerTray;
        }
    }

    thisRecord[toFieldName] = roundToDecimal(thisRecord[toFieldName], roundDecimal);

    return true;
}

function getCurrentDateTime (format){
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!
    var yyyy = today.getFullYear();
    var hh = parseInt(today.getHours());
    var m = today.getMinutes();
    var ampm = (hh < 12) ? 'AM' : 'PM';
    
    if (hh == 0) {
        hh = 12;
    }
    if (hh > 12) {
        hh = hh - 12;
    }

    if (format == 'date'){
        return mm + '/' + dd + '/' + yyyy;
    }else if (format == 'time'){
        return hh + ':' + m + ' ' + ampm;
    }else {
        return mm + '/' + dd + '/' + yyyy + ' ' + hh + ':' + m + ' ' + ampm;
    }
}

function incubatorLoadFieldChange(detailRecords, thisRecord, fieldName) {

    if (thisRecord.ActualQty != 0 && thisRecord.ActualQty != EggsPerIncubatorCart && parseInt(thisRecord.ActualQty) != 0) {
        thisRecord.className = 'yellowBackground';
    } else {
        thisRecord.className = '';
    }
    IncubatorLoad_Recalc(detailRecords, thisRecord);
    thisRecord.thisRowHasChanged = true;

    return true;
}

function holdingIncubatorLoadFieldChange(detailRecords, thisRecord, fieldName) {

    if (fieldName == 'Carts1' ||
        fieldName == 'Shelves1' ||
        fieldName == 'Trays1' ||
        fieldName == 'Eggs1' ||
        fieldName == 'Carts2' ||
        fieldName == 'Shelves2' ||
        fieldName == 'Trays2' ||
        fieldName == 'Eggs2'
        ) {


        if (thisRecord.Carts1 == '') { thisRecord.Carts1 = '0'; }
        if (thisRecord.Shelves1 == '') { thisRecord.Shelves1 = '0'; }
        if (thisRecord.Trays1 == '') { thisRecord.Trays1 = '0'; }
        if (thisRecord.Eggs1 == '') { thisRecord.Eggs1 = '0'; }
        if (thisRecord.Carts2 == '') { thisRecord.Carts2 = '0'; }
        if (thisRecord.Shelves2 == '') { thisRecord.Shelves2 = '0'; }
        if (thisRecord.Trays2 == '') { thisRecord.Trays2 = '0'; }
        if (thisRecord.Eggs2 == '') { thisRecord.Eggs2 = '0'; }


        thisRecord.ActualQty1 = parseInt(thisRecord.Carts1 * EggsPerDeliveryCart) +
                                parseInt(thisRecord.Shelves1 * EggsPerDeliveryShelf) +
                                parseInt(thisRecord.Trays1 * EggsPerTray) +
                                parseInt(thisRecord.Eggs1);
        thisRecord.ActualQty2 = parseInt(thisRecord.Carts2 * EggsPerDeliveryCart) +
                                parseInt(thisRecord.Shelves2 * EggsPerDeliveryShelf) +
                                parseInt(thisRecord.Trays2 * EggsPerTray) +
                                parseInt(thisRecord.Eggs2);


        if (thisRecord.ActualQty1 != EggsPerDeliveryCart && parseInt(thisRecord.ActualQty1) + parseInt(thisRecord.ActualQty2) != EggsPerDeliveryCart && parseInt(thisRecord.ActualQty1) != 0) {
            thisRecord.className = 'yellowBackground';
        } else {
            thisRecord.className = '';
        }
        thisRecord.thisRowHasChanged = true;


    }



    return true;
}

function roundToDecimal(value, decimal) {
    return Math.round(value * Math.pow(10, decimal)) / Math.pow(10, decimal);
}

/*******************************************************************************
autoCompleteOnSelectCustom() - This function is called when an option is
                               selected in a JQuery auto-complete control.
*******************************************************************************/

function autoCompleteOnSelectCustom(screenID, fieldName, inputControl, event, ui) {
}

function passwordValidationCustom() {
    //return an array of four values containing password requirements
    //requirements = [# capital, # lowercase, #special, # numbers, #total min length]
    var requirements = [0, 0, 1, 1, 8];
    return requirements;
}

/*******************************************************************************
It is recommended that you put your custom JavaScript below here and organize
it by screen.
*******************************************************************************/

function setFixedTop(grid) {
    var $rt = $(grid + " thead");

    var TableTop = $rt.offset().top;
    var columnWidth = $(grid + " tbody").find('tr:first').find('td').toArray();
    
    $(window).scroll(function () {
        if ($(window).scrollTop() + 50 > TableTop) {
            $rt.addClass("fixedTop");
            $(grid + " thead td").each(function () {
                var columnIndex = $(this).index();
                $(this).width($(columnWidth[columnIndex]).width());
            });
        } else {
            $rt.removeClass("fixedTop");
        }

    });
}


function updateFlockPlan(PulletFarmPlanID) {
	alert(PulletFarmPlanID);

	var screenID = "PulletFarmPlan_Form";
	var sURL = "RenderMenu.aspx?screenID=" + screenID;
	//SendRequest(sURL);

}

function add_weeks(dt, n) {
	return new Date(dt.setDate(dt.getDate() + (n * 7)));
}

function add_days(dt, n) {
	return new Date(dt.setDate(dt.getDate() + (n)));
}

function CompareDates(strDate1, strDate2, strComparison) {
	var result = false;

	var date1_array = strDate1.split("/");
	var date1_date = new Date(date1_array[2], parseInt(date1_array[0]) - 1, date1_array[1]);
	var date2_array = strDate2.split("/");
	var date2_date = new Date(date2_array[2], parseInt(date2_array[0]) - 1, date2_array[1]);

	// Is the string comparison keyword "Equal To"?
	if (/^Equal/.test(strComparison) == true) {
		result = date1_date == date2_date;
	}
	else {
		// Is it greater than or greater than equal to
		if (/^Great/.test(strComparison) == true) {
			if (/Equal/.test(strComparison) == true) {
				result = date1_date >= date2_date;
			}
			else {
				result = date1_date > date2_date;
			}
		}
		else {
			// Is it less than or less than equal to
			if (/^Less/.test(strComparison) == true) {
				if (/Equal/.test(strComparison) == true) {
					result = date1_date <= date2_date;
				}
				else {
					result = date1_date < date2_date;
				}
			}
		}
	}
	return result;
}

function convertStringToDate(stringDate) {
	var inputDate = stringDate;
	var date_array = inputDate.split("/");
	var returnDate = new Date(date_array[2], parseInt(date_array[0]) - 1, date_array[1]);
	return returnDate;
}

function validateNewFlock(filterSet, detailRecords, columnNbr) {

	var returnValue = true;
	var strColumnNbr = '00' + columnNbr.toString().trim();
	var farmListRec = parseInt(columnNbr.trim()) - 1;
	//var farmIDString = "filterSet.FarmID" + strColumnNbr.slice(strColumnNbr.length - 2, strColumnNbr.length);
	

	var beginDateString = "filterSet.Date" + strColumnNbr.slice(strColumnNbr.length - 2, strColumnNbr.length);

	//var farmID = eval(farmIDString);
	var farmID = detailRecords[0].FlockRotation_FarmList[farmListRec].FarmID;
	var beginDate = eval(beginDateString);
	var FlockDates = detailRecords[0].FlockRotation_FlockDateRanges;



	var testStartDate = convertStringToDate(beginDate);
	var testEndDate = convertStringToDate(beginDate);
	testEndDate = add_weeks(testEndDate, 41);

	var idealDaysBetweenFlocks = 77;
	var minDaysBetweenFlocks = 1;

	console.log(FlockDates);
	var flockDatesRecCount = FlockDates.length;

	for (var i = 0; i < FlockDates.length; i++) {
		if (returnValue) {
			// Last we checked, this was a valid plan, 
			// Let's confirm against the next pullet flock plan
			var currentRow = FlockDates[i];
			var savedStartDate = convertStringToDate(currentRow.SavedStartDate);
			var savedEndDate = convertStringToDate(currentRow.SavedEndDate);


			if (currentRow.FarmID == farmID) {
				//(StartA <= EndB) and
				//(EndA >= StartB)		
				//Check Farm to see if this plan overlaps with any existing flocks
				// Adjust the actual planned end date back to include the ideal days between flocks!

				var adjSavedEndDate = convertStringToDate(currentRow.SavedEndDate);
				adjSavedEndDate = add_days(adjSavedEndDate, idealDaysBetweenFlocks)

				if (
					(testStartDate <= adjSavedEndDate) &&
					(testEndDate >= savedStartDate)
				) {
					// We have overlap with the planned!
					returnValue = confirm("This new 24 week date does not allow 11 weeks after the last flock; do you want to continue?");
				}
			}
		}
	}

	if (returnValue == false) {
		controlID = "#Date" + strColumnNbr.slice(strColumnNbr.length - 2, strColumnNbr.length);
		//alert(controlID);
		//document.getElementById(controlID).value = "";
		//document.getElementById(controlID).valueAsDate = null;
		$(controlID).val('');
	}

	return returnValue;

//	return true;
}

function good_validateNewFlock(filterSet, FlockDates, farmColumn, farmID, beginDate) {

	var returnValue = true;
	var plan24WeekDate_array = beginDate.split("/");
	var plan24WeekDate = new Date(plan24WeekDate_array[2], parseInt(plan24WeekDate_array[0]) - 1, plan24WeekDate_array[1]);

	var plan65WeekDate = new Date();
	var plan65WeekDate = add_weeks(plan24WeekDate, 41);

	var idealDaysBetweenFlocks = 14;
	var minDaysBetweenFlocks = 10;

	console.log(FlockDates);
	var flockDatesRecCount = FlockDates.length;

	//alert(flockDatesRecCount);

	for (var i = 0; i < FlockDates.length; i++) {
		//alert("Got Here!");
		//alert(returnValue);
		if (returnValue) {
			// Last we checked, this was a valid plan, 
			// Let's confirm against the next pullet flock plan
			var currentRow = FlockDates[i];


			var test = currentRow.Target24WeekDate;
			var savedTarget24WeekDate = convertStringToDate(currentRow.Target24WeekDate);
			var savedTargetEndDate = convertStringToDate(currentRow.TargetEndDate);


			if (currentRow.FarmID == farmID) {
				//StartA <= EndB) and(EndA >= StartB)		
				//Check Farm to see if this plan overlaps with any existing flocks
				if (
					(plan24WeekDate <= add_days(savedTargetEndDate, idealDaysBetweenFlocks)) &&
					(plan65WeekDate >= savedTarget24WeekDate)
				) {
					// We have overlap with the planned!
					// So, we know this is not ideal, but is it doable?
					if (
						(plan24WeekDate <= add_days(savedTargetEndDate, minDaysBetweenFlocks)) &&
						(plan65WeekDate >= savedTarget24WeekDate)
					) {
						// This is not doable!
						returnValue = false;
						alert("This flock 24 date does not allow for sufficient time between the planned flocks!");
					}
					else {
						returnValue = confirm("This planned flock 24 week date does not allow 14 days between the planned flocks, do you want to continue?");
					}
				}
				else {
					// it doesn't overlap with the planned, does it overlap with actuals?
					if (currentRow.Actual24WeekDate == "" || currentRow.ActualEndDate == "") {
						// Nothing to worry about, no actuals to compare
					}
					else {

						var savedActual24WeekDate = convertStringToDate(currentRow.Actual24WeekDate);
						var savedActualEndDate = convertStringToDate(currentRow.ActualEndDate);

						if (
							(plan24WeekDate <= add_days(savedActualEndDate, idealDaysBetweenFlocks)) &&
							(plan65WeekDate >= savedActual24WeekDate)
						) {
							// We have overlap with the actuals!
							// So, we know this is not ideal, but is it doable?
							if (
								(plan24WeekDate <= add_days(savedActualEndDate, minDaysBetweenFlocks)) &&
								(plan65WeekDate >= savedActual24WeekDate)
							) {
								// This is not doable!
								returnValue = false;
								alert("This flock 24 date does not allow for sufficient time between the actual flocks!");
							}
							else {
								returnValue = confirm("This planned flock 24 week date does not allow 14 days between the actual flocks, do you want to continue?");
							}
						}

					}

				}
			}
		}
	}
	
	return returnValue;
}
//Consider moving the following two functions to solution builder
function respaceLeftNav() {
    // Fix bottom floating element height
    $('#leftContentContainer').css('min-height', $('#xmlLeftMenu').height() + 5);
    
    if ($('.bottom-link').length) {
//        alert('bottom found');
        if (!$('#left-menu-spacer').length) {
//            alert('adding spacer');
            $('.bottom-link:first').before('<div id="left-menu-spacer" class="hidden-xs">&nbsp;</div>');
        }

        var bHeight = 0;
        $('#leftContentContainer ul').children().not('#left-menu-spacer').each(function () {
            bHeight += $(this).outerHeight(true);
//            alert($(this).outerHeight(true) + ': ' + bHeight);
        });
//        alert($('#leftContentContainer').innerHeight());
        $('#left-menu-spacer').height($('#leftContentContainer').innerHeight() - bHeight);
    }

    
}

function moveLeftNav() {
    if ($('.leftMenu').css('display') == 'none') {
        if (!$.contains('#cssmenu', '#cssleftmenu>ul')) {
            //$('#cssleftmenu>ul').removeClass('sm-vertical').removeClass('sm-simple-vertical').addClass('sm-simple');
            $('#cssleftmenu>ul').children().addClass('originallyLeftMenu');
            $('#cssleftmenu>ul').children().insertAfter('#menu-button');
            renderSmartMenu('#userMenu');
        }
    } else {
        if (!$.contains('#leftMenu', '#cssleftmenu>ul')) {
            //alert('put it back');
            //$('#cssleftmenu>ul').addClass('sm-vertical').addClass('sm-simple-vertical').removeClass('sm-simple');
            $('.originallyLeftMenu').appendTo('#cssleftmenu>ul');
            $('.originallyLeftMenu').removeClass('originallyLeftMenu');
            renderSmartMenu('#userMenu');
            
        }
        respaceLeftNav();
    }
}

function renderSmartMenu(menuElement) {
    //$(menuElement).smartmenus({
    //    subMenusSubOffsetX: 1,
    //    subMenusSubOffsetY: 0,
    //    subIndicators: false,
    //    subMenusMinWidth: '13em',
    //});
}
function getMenuToRender(screenID) {
    // Set XMLHTTPRequest Type
    RequestType = "menu";
    // If empty, get the menu.
    //document.body.style.cursor = 'wait';
    $('#cssMenu').prepend('<p id="navbar-loading-text" class="navbar-text">Menu is loading...</p>');
    // Save the selected menu option to the hidden field (for postback)
    //document.forms[0].selectedMenu.value = screenID;
    $("#selectedMenu").val(screenID);
    gl_screenID = screenID;
    // Create the URL to get the menu
    var sURL = "RenderMenu.aspx?screenID=" + screenID
    SendRequest(sURL);
}

function fireCSBLink_DefineLink(thisControl, attributeName) {
	//alert(thisControl.getAttribute("csb-link"));

	//eval(thisControl.getAttribute("csb-link"));
	var functionCall = thisControl.getAttribute(attributeName);
	//var functionCall = fireThisLink;
	var functionCallNoParams = functionCall.substring(0, functionCall.indexOf('('));
	var functionParams = functionCall.substring(functionCall.indexOf('(') + 1, functionCall.indexOf(')')).replace(/' /g, '').replace(/ '/g, '').replace(/'/g, '').split(',');

	var fn = window[functionCallNoParams];
	if (typeof fn === "function") {
		//alert('found');
		fn.apply(null, functionParams);
	}

}

//THIS MUST STAY AT THE END OF THIS SCRIPT
function fireCSBLink(thisControl) {
    //alert(thisControl.getAttribute("csb-link"));

    //eval(thisControl.getAttribute("csb-link"));
    var functionCall = thisControl.getAttribute("csb-link");
    var functionCallNoParams = functionCall.substring(0, functionCall.indexOf('('));
    var functionParams = functionCall.substring(functionCall.indexOf('(') + 1, functionCall.indexOf(')')).replace(/' /g,'').replace(/ '/g,'').replace(/'/g,'').split(',');
    
    var fn = window[functionCallNoParams];
    if (typeof fn === "function") {
        //alert('found');
        fn.apply(null,functionParams);
    }

}
