<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.text.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <title>Ledger</title>
    <link href="./css/entryPage.css" rel="stylesheet" type="text/css">
</head>
<body onload="populateEntrySelection(),createNewBillingForm();">

  <br>
  <div class="container" >

    <div id="entrySelectionContainer" onchange="showPatientDetails(),removeAllBillings(),resetNewBillingForm();">
      <select id="entryNames">
        <option value = 0>Create New Entry</option>
      </select>
    </div>

    <div id="entryDetails">
      <br>

      <div>
        <label for="initials">Initials</label>
        <input type="text" id="initials" name="initials" onkeyup="this.value = this.value.toUpperCase();">&nbsp;&nbsp;

        <label for="age">Age</label>
        <input type="number" id="age" name="age">
      </div><br>

      <label class="fieldLabels" for="startDate">Start Date</label>
      <input type="date" class="fieldInputs" id="startDate" name="startDate" onchange="updateNewBillingDate()"><br><br>

      <button type="button" class="btn btn-default btn-sm" id="btnEditEntryLedger" onclick="enableEntryLedgerEditing();">
        <span class="glyphicon glyphicon-pencil" id="editIcon"></span>
      </button>
      <button type="button" class="btn btn-default btn-sm" id="btnUpdateEntryLedger" onclick="updateEntryLedger();">
        <span class="glyphicon glyphicon-save" id="saveIcon"></span>
      </button>&nbsp;&nbsp;
      <button type="button" class="btn btn-default btn-sm" id="btnCancelUpdate" onclick="cancelEditingLedger();">
        <span class="glyphicon glyphicon-remove" id="saveIcon"></span>
      </button>


    </div><br>

    <div id="newBilling">
        <div id="newBillingDynamic"></div>

        <div id="newBillingStaticInput">
          <label class="fieldLabels" for="newServiceDate">Bill Date</label>
          <input type="date" class="fieldInputs" id="newServiceDate" name="newServiceDate"><br><br>
          <input type="checkbox" id="newBilledCheckbox" name="newBilledCheckbox">
          <label for="newBilledCheckbox">Billed&nbsp;&nbsp;&nbsp;</label>

          <input type="checkbox" id="newReportCompleteCheckbox" name="newReportCompleteCheckbox">
          <label for="newReportCompleteCheckbox">Reported</label>
        </div>
    </div>

    <div id="billings"></div>

    <div id="updateEntries">
      <button class="btn btn-primary" id="btnComplete" type="button" onclick="saveLedgerEntry(true);">COMPLETE</button>
      <button class="btn btn-primary" id="btnSave" type="button" onclick="saveLedgerEntry(false);">SAVE</button>
    </div><br><br><br><br><br>

    <div>
      <button id="btnViewLedger" class="btn btn-primary" onclick="window.location.href='./ledger';">VIEW LEDGER</button><br>
    </div>
  </div>

</body>
</html>

<script>
function populateEntrySelection() {
    document.getElementById("startDate").value = getTodaysDate();
    setNewServiceDateToToday();
    fetch('./entrySelection', {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(entries => {
        var entryDropdown = document.getElementById("entryNames");
        for (i in entries) {
            var entryOption = document.createElement("option");
            entryOption.value = entries[i].ledgerEntry.id;
            entryOption.innerHTML = entries[i].name;
            entryDropdown.appendChild(entryOption);
        }
    });
    showPatientDetails();
}
function showPatientDetails() {
    var entryId = document.getElementById("entryNames").value;

    if (entryId != 0) {
        disableEntryLedgerEditing()
        document.getElementById("btnEditEntryLedger").style.display = "inline-block";
        showEntryDetailInputs(false);
        fetch('./ledgerEntry/' + entryId, {
            method: 'GET',
            headers: {'Content-type': 'application/json'}
        })
        .then(response => response.json())
        .then(dto => {
            showEntryDetailInputs();

            var initialsInput = document.getElementById("initials");
            initialsInput.value = dto.ledgerEntry.initials;

            var ageInput = document.getElementById("age");
            ageInput.value = dto.ledgerEntry.age;

            var startDateInput = document.getElementById("startDate");
            startDateInput.value = dto.ledgerEntry.startDate;

            getAndPopulateBillings(entryId);
        });
    } else {
        showEntryDetailInputs(true);
        document.getElementById("initials").value = "";
        document.getElementById("age").value = "";
        document.getElementById("startDate").value = getTodaysDate();
        disableEditingButtons();
    }
}
function getAndPopulateBillings(ledgerEntryId) {
    fetch('./billings/'+ledgerEntryId, {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(ledgerEntryDetailsDto => {
        populateExistingBillings(ledgerEntryDetailsDto);
    });
}
function createNewBillingForm() {
    fetch('./billingOptions', {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(dto => {
        var newBillingDiv = document.getElementById("newBillingDynamic");

        var categoryList = document.createElement("ul");
        for (categoryId in dto.categoryMap) {
            var categoryListItem = document.createElement("li");
            categoryListItem.id = "categoryId_" + categoryId;

            var categoryInput = document.createElement("input");
            categoryInput.type = "radio";
            categoryInput.id = "newCategory_" + categoryId;
            categoryInput.name = "newCategorySelection";
            categoryInput.value = categoryId;
            categoryInput.onclick = function(){showBillingTypesForCategory();};

            categoryListItem.appendChild(categoryInput);

            var categoryLabel = document.createElement("label");
            categoryLabel.htmlFor = categoryInput.id;
            categoryLabel.innerHTML = dto.categoryMap[categoryId];
            categoryListItem.appendChild(categoryLabel);

            categoryList.appendChild(categoryListItem);

            var billingTypeList = document.createElement("ul");
            billingTypeList.className = "billingTypeList";
            billingTypeList.hidden = true;
            billingTypeList.id = categoryListItem.id + "_billings";
            for (i in dto.categoryToBillingTypesMap[categoryId]) {
                var billingTypeId = dto.categoryToBillingTypesMap[categoryId][i];

                var billingTypeListItem = document.createElement("li");
                billingTypeListItem.id = "billingTypeId_" + categoryId + "-" + billingTypeId;

                var billingTypeInput = document.createElement("input");
                billingTypeInput.type = "radio";
                billingTypeInput.id = "newBillingType_" + categoryId + "-" + billingTypeId;
                billingTypeInput.name = "newBillingTypeSelection";
                billingTypeInput.value = billingTypeId;
                billingTypeListItem.appendChild(billingTypeInput);

                var billingTypeLabel = document.createElement("label");
                billingTypeLabel.htmlFor = billingTypeInput.id;
                billingTypeLabel.innerHTML = dto.billingTypeMap[billingTypeId];
                billingTypeListItem.appendChild(billingTypeLabel);

                billingTypeList.appendChild(billingTypeListItem);
            }
            categoryList.appendChild(billingTypeList);

        }
        newBillingDiv.appendChild(categoryList);
    });
}
function populateExistingBillings(dto) {
    var billingsDiv = document.getElementById("billings");
    for (i in dto.billings) {
        var billingDiv = document.createElement("div");
        billingDiv.id = "billing_" + dto.billings[i].id;

        var billingCategoryAndType = document.createElement("h3");
        billingCategoryAndType.innerHTML = dto.categoryMap[dto.billings[i].categoryId] + ": " + dto.billingTypeMap[dto.billings[i].billingTypeId];
        billingDiv.appendChild(billingCategoryAndType);

        var serviceDate = document.createElement("p");
        serviceDate.innerHTML = dto.billings[i].serviceDate;
        billingDiv.appendChild(serviceDate);

        var billingId = dto.billings[i].id;
        var checkboxesDiv = document.createElement("div");
        checkboxesDiv.id = "checkboxes_" + billingId;

        var billedInput = document.createElement("input");
        billedInput.type = "checkbox";
        billedInput.id = "billed_" + billingId;
        billedInput.name = "billed_" + billingId;
        billedInput.checked = dto.billings[i].billed;
        billedInput.disabled = dto.billings[i].billed;
        checkboxesDiv.appendChild(billedInput);
        var billedLabel = document.createElement("label");
        billedLabel.htmlFor = "billed_" + billingId;
        billedLabel.innerHTML = "&nbsp;Billed&nbsp;&nbsp;&nbsp;&nbsp;";
        checkboxesDiv.appendChild(billedLabel);

        var completedInput = document.createElement("input");
        completedInput.type = "checkbox";
        completedInput.id = "reportComplete_" + billingId;
        completedInput.name = "reportComplete_" + billingId;
        completedInput.checked = dto.billings[i].reportComplete;
        completedInput.disabled = dto.billings[i].reportComplete;
        checkboxesDiv.appendChild(completedInput);
        var completedLabel = document.createElement("label");
        completedLabel.htmlFor = "reportComplete_" + billingId;
        completedLabel.innerHTML = "&nbsp;Reported";
        checkboxesDiv.appendChild(completedLabel);

        billingDiv.appendChild(checkboxesDiv);
        billingsDiv.appendChild(billingDiv);
    }
}
function createAndPopulateNewBilling(newBillingDto, ledgerEntryId, finalize) {
    newBillingDto.ledgerEntryId = ledgerEntryId;
    fetch("./billing", {
        method: "POST",
        body: JSON.stringify(newBillingDto),
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(newLedgerEntryDetailsDto => {
        console.log(newLedgerEntryDetailsDto.billings);
        var newBillingId = newLedgerEntryDetailsDto.billings[0].id;
        if (!newLedgerEntryDetailsDto.billings) {
            alert("New Billing could not be Created.");
            return;
        } else {
            console.log("New Billing Created: " + newBillingId);
            fetch('./billing/'+newBillingId, {
                method: 'GET',
                headers: {'Content-type': 'application/json'}
            })
            .then(response => response.json())
            .then(ledgerEntryDetailsDto => {
                console.log(ledgerEntryDetailsDto.billings);
                populateExistingBillings(ledgerEntryDetailsDto);
                resetNewBillingForm();
            });
        }
        if (finalize) {
            finalizeLedgerEntry()
        }
        enableSaveButton();
    });
}



// BUTTON FUNCTIONS
function saveLedgerEntry(finalize) {
    disableSaveButton();
    var ledgerEntryId = document.getElementById("entryNames").value;

    // find previous billings
    var previousBillings = Array.from(document.querySelectorAll('[id^=checkboxes_]'));

    for (i in previousBillings) {
        billingId = previousBillings[i].id.split("_")[1];
        let billedCheckbox = document.getElementById("billed_"+billingId);
        let reportCompleteCheckbox = document.getElementById("reportComplete_"+billingId);

        billingDto = {
            id: billingId,
            billed: billedCheckbox.checked,
            reportComplete: reportCompleteCheckbox.checked
        };

        fetch("./billing", {
            method: "PUT",
            body: JSON.stringify(billingDto),
            headers: {'Content-type': 'application/json'}
            })
        .then(response => response.json())
        .then(billing => {
            console.log("billing: " + JSON.stringify(billing));
            if (billing.billed) {
                billedCheckbox.disabled = true;
            }
            if (billing.reportComplete) {
                reportCompleteCheckbox.disabled = true;
            }
        });
    }

    if (ledgerEntryId == 0) {
        // Ledger Does not exist yet. Create it.
        initials = document.getElementById("initials").value;
        if (!initials) {
            alert("Missing Initials. Cannot create entry.");
            enableSaveButton();
            return;
        }
        age = document.getElementById("age").value;
        if (!age) {
            alert("Missing Age. Cannot create entry.");
            enableSaveButton();
            return;
        }
        startDateString = document.getElementById("startDate").value;
        if (!startDateString) {
            alert("Missing Start Date. Cannot create entry.");
            enableSaveButton();
            return;
        }

        var newLedgerEntryDto = {
            initials: initials,
            age: age,
            startDate: getDateForSubmission(startDateString),
            entryComplete: false
        };

        fetch("./ledgerEntry", {
            method: "POST",
            body: JSON.stringify(newLedgerEntryDto),
            headers: {'Content-type': 'application/json'}
            })
        .then(response => response.json())
        .then(newLedgerEntryDetailsDto => {
            var newLedgerEntryId = newLedgerEntryDetailsDto.ledgerEntry.id;
            if (!newLedgerEntryId) {
                alert("New Entry could not be Created.");
                enableSaveButton();
                return;
            } else {
                var entryDropdown = document.getElementById("entryNames");
                var newEntryOption = document.createElement("option");
                newEntryOption.value = newLedgerEntryId;
                newEntryOption.innerHTML = newLedgerEntryDetailsDto.name;
                newEntryOption.selected = true;
                entryDropdown.appendChild(newEntryOption);
                showEntryDetailInputs(false);
                var newBillingDto = getNewBillingDto();
                if (newLedgerEntryId && newBillingDto) {
                    console.log("New Ledger Entry Created: " + newLedgerEntryId);
                    createAndPopulateNewBilling(newBillingDto, newLedgerEntryId, finalize);
                } else {
                    if (finalize) {
                        finalizeLedgerEntry()
                    }
                    enableSaveButton();
                }
            }
        });
    } else {
        // Ledger Entry exists already, but need to collect changes to other billings
        var newBillingDto = getNewBillingDto();
        if (newBillingDto != null) {
            createAndPopulateNewBilling(newBillingDto, ledgerEntryId, finalize);
        } else {
            if (finalize) {
                finalizeLedgerEntry()
            }
            enableSaveButton();
        }
    }
}
function finalizeLedgerEntry() {
    disableCompleteButton();
    // POSSIBLE RACE CONDITION, if billing is not created and put on the page before the update check, this wont work.
    // Check if all billings are both billed and reportComplete

    // saveLedgerEntry();
    // var now = Date.now();
    // var end = now + 1000;
    // while (now < end) { now = Date.now(); }

    var selectedCategory = document.querySelector('input[name="newCategorySelection"]:checked');
    var selectedBillingType = document.querySelector('input[name="newBillingTypeSelection"]:checked');
    var newServiceDate = getDateForSubmission(document.getElementById("newServiceDate").value);
    var billedCheckboxChecked = document.getElementById("newBilledCheckbox").checked;
    var reportCompleteCheckboxChecked = document.getElementById("newReportCompleteCheckbox").checked;

    // If user checked at least one of these, they probably meant to check more
    // Notify User that a field is missing.
    if (selectedCategory || selectedBillingType || billedCheckboxChecked || reportCompleteCheckboxChecked) {
        if (!selectedCategory || !selectedBillingType || !newServiceDate) {
            if (!confirm("Oops, new billing started but incomplete! Do you want to ignore it?")) {
                enableCompleteButton();
                return;
            }
        } else {
            if (!confirm("Are you sure?")) {
                enableCompleteButton();
                return;
            }
        }
    } else {
        if (!confirm("Are you sure?")) {
            enableCompleteButton();
            return;
        }
    }

    var ledgerEntryId = document.getElementById("entryNames").value;
    fetch("./completeLedgerEntry/"+ledgerEntryId, {
        method: "PATCH",
        headers: {'Content-type': 'application/json'}
        })
    .then(response => response.json())
    .then(ledgerEntry => {
        if (ledgerEntry && ledgerEntry.entryComplete) {
            window.location.reload(true);
        } else {
            alert("Could not Complete Entry. Add a billing or make sure all billings are complete.");
            enableCompleteButton();
        }
    });
}



// HELPER FUNCTIONS
function getNewBillingDto() {
    var ledgerEntryId = document.getElementById("entryNames").value;

    var previousBillingsExist = document.getElementById("billings").hasChildNodes();
    var selectedCategory = document.querySelector('input[name="newCategorySelection"]:checked');
    var selectedBillingType = document.querySelector('input[name="newBillingTypeSelection"]:checked');
    var newServiceDate = getDateForSubmission(document.getElementById("newServiceDate").value);
    var billedCheckboxChecked = document.getElementById("newBilledCheckbox").checked;
    var reportCompleteCheckboxChecked = document.getElementById("newReportCompleteCheckbox").checked;

    // If user checked at least one of these, they probably meant to check more OR if no previous billings exist
    // Notify User that a field is missing.
    if (!previousBillingsExist || selectedCategory || selectedBillingType || billedCheckboxChecked || reportCompleteCheckboxChecked) {
        if (!selectedCategory) {
            alert("Missing Category. Cannot create billing.");
            return null;
        } else {
            var categoryId = selectedCategory.value ;
        }

        if (!selectedBillingType) {
            alert("Missing Billing Type. Cannot create billing.");
            return null;
        } else {
            var billingTypeId = selectedBillingType.value;
        }

        if (!newServiceDate) {
            alert("Missing Service Date. Cannot create billing.");
            return null;
        }
    }

    if (!categoryId && !billingTypeId && !billedCheckboxChecked && !reportCompleteCheckboxChecked) {
        return null;
    } else {
        return {
            ledgerEntryId: ledgerEntryId,
            categoryId: categoryId,
            billingTypeId: billingTypeId,
            serviceDate: newServiceDate,
            billed: billedCheckboxChecked,
            reportComplete: reportCompleteCheckboxChecked
        };
    }
}
function showEntryDetailInputs(show) {
    document.getElementById("initials").disabled = !show;
    document.getElementById("age").disabled = !show;
    document.getElementById("startDate").disabled = !show;
}
function removeAllBillings() {
    document.getElementById("billings").innerHTML = '';
}
function showBillingTypesForCategory() {
    hideAllBillingTypeLists();
    var selectedCategoryId = document.querySelector('input[name="newCategorySelection"]:checked').value;
    var billingTypes = document.getElementById("categoryId_" + selectedCategoryId + "_billings");
    billingTypes.hidden = false;
}
function hideAllBillingTypeLists() {
    var allBillingTypes = document.getElementsByClassName("billingTypeList");
    for (i in allBillingTypes) {
        allBillingTypes[i].hidden = true;
    }
    var selectedBillingType = document.querySelector('input[name="newBillingTypeSelection"]:checked');
    if (selectedBillingType != null) {
        document.querySelector('input[name="newBillingTypeSelection"]:checked').checked = false;
    }
}
function unselectAllCategorySelections() {
    var selectedCategory = document.querySelector('input[name="newCategorySelection"]:checked');
    if (selectedCategory != null) {
        document.querySelector('input[name="newCategorySelection"]:checked').checked = false;
    }
}
function resetNewBillingForm() {
    unselectAllCategorySelections();
    hideAllBillingTypeLists();
    setNewServiceDateToToday();
    document.getElementById("newBilledCheckbox").checked = false;
    document.getElementById("newReportCompleteCheckbox").checked = false;
}
function setNewServiceDateToToday() {
    document.getElementById("newServiceDate").value = getTodaysDate();
}
function getTodaysDate() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    return today;
}
function getDateForSubmission(dateString) {
    var rawDate =new Date(dateString);
    var offsetHours = rawDate.getTimezoneOffset()/60;
    rawDate.setHours(rawDate.getHours()+offsetHours);
    var dateToPost = new Date();
    dateToPost.setFullYear(rawDate.getFullYear());
    dateToPost.setMonth(rawDate.getMonth());
    dateToPost.setDate(rawDate.getDate());
    return dateToPost;
}
function updateNewBillingDate() {
    var entryDate = document.getElementById("startDate").value;
    document.getElementById("newServiceDate").value = entryDate;
}
function disableSaveButton() {
    document.getElementById("btnSave").disabled = true;
    document.getElementById("btnSave").innerHTML = "Saving...";
}
function disableCompleteButton() {
    document.getElementById("btnComplete").disabled = true;
    document.getElementById("btnComplete").innerHTML = "Completing...";
}
function enableSaveButton() {
    document.getElementById("btnSave").disabled = false;
    document.getElementById("btnSave").innerHTML = "SAVE";
}
function enableCompleteButton() {
    document.getElementById("btnComplete").disabled = false;
    document.getElementById("btnComplete").innerHTML = "COMPLETE";
}
function enableEntryLedgerEditing() {
    document.getElementById("btnEditEntryLedger").style.display = "none";
    document.getElementById("btnUpdateEntryLedger").style.display = "inline-block";
    document.getElementById("btnCancelUpdate").style.display = "inline-block";
    showEntryDetailInputs(true);
}
function disableEntryLedgerEditing() {
    document.getElementById("btnEditEntryLedger").style.display = "inline-block";
    document.getElementById("btnUpdateEntryLedger").style.display = "none";
    document.getElementById("btnCancelUpdate").style.display = "none";
    showEntryDetailInputs(false);
}
function disableEditingButtons() {
    document.getElementById("btnEditEntryLedger").style.display = "none";
    document.getElementById("btnUpdateEntryLedger").style.display = "none";
    document.getElementById("btnCancelUpdate").style.display = "none";
}
function updateEntryLedger() {
    disableEntryLedgerEditing();
    var ledgerEntryId = document.getElementById("entryNames").value;

    var ledgerEntry = new Object();
    ledgerEntry.id = ledgerEntryId;
    ledgerEntry.initials = document.getElementById("initials").value;
    ledgerEntry.age = document.getElementById("age").value;
    ledgerEntry.startDate = getDateForSubmission(document.getElementById("startDate").value);

    fetch("./ledgerEntry", {
        method: "PATCH",
        body: JSON.stringify(ledgerEntry),
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(savedLedgerEntry => {
        if (savedLedgerEntry != null && savedLedgerEntry.id == ledgerEntry.id) {
            showEntryDetailInputs(false);
        } else {
            alert("Oops! Something went wrong. Could Not Save Entry Details.");
        }
        resetEntryDetailsWithCurrentEntry(ledgerEntryId);
    });
}
function cancelEditingLedger() {
    var ledgerEntryId = document.getElementById("entryNames").value;
    resetEntryDetailsWithCurrentEntry(ledgerEntryId);
}
function resetEntryDetailsWithCurrentEntry(ledgerEntryId) {
    disableEntryLedgerEditing();
    fetch('./ledgerEntry/'+ledgerEntryId, {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(ledgerEntryDetailsDto => {
        console.log(ledgerEntryDetailsDto.ledgerEntry)
        document.getElementById("initials").value = ledgerEntryDetailsDto.ledgerEntry.initials;
        document.getElementById("age").value = ledgerEntryDetailsDto.ledgerEntry.age;
        document.getElementById("startDate").value = ledgerEntryDetailsDto.ledgerEntry.startDate;
        var entryDropdown = document.getElementById("entryNames");
        entryDropdown.options[entryDropdown.selectedIndex].text = ledgerEntryDetailsDto.name;
    });
}
</script>