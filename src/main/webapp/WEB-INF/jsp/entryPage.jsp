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
        <input type="text" id="initials" name="initials">&nbsp;&nbsp;

        <label for="age">Age</label>
        <input type="number" id="age" name="age">
      </div><br>

      <label class="fieldLabels" for="startDate">Start Date</label>
      <input type="date" class="fieldInputs" id="startDate" name="startDate"><br><br>

      <label class="fieldLabels" for="endDate">End Date</label>
      <input type="date" class="fieldInputs" id="endDate" name="endDate"><br><br>
    </div><br>

    <div id="newBilling">
        <div id="newBillingDynamic"></div>

        <div id="newBillingStaticInput">
          <label class="fieldLabels" for="newBillingDate">Billing Date</label>
          <input type="date" class="fieldInputs" id="newBillingDate" name="newBillingDate"><br><br>
          <input type="checkbox" id="newBilledCheckbox" name="newBilledCheckbox">
          <label for="newBilledCheckbox">&nbsp;Billed&nbsp;&nbsp;&nbsp;&nbsp;</label>

          <input type="checkbox" id="newReportCompleteCheckbox" name="newReportCompleteCheckbox">
          <label for="newReportCompleteCheckbox">&nbsp;Report Complete</label>
        </div>
    </div>

    <div id="billings"></div>

  </div>

</body>
</html>

<script>
function populateEntrySelection() {
    document.getElementById("startDate").value = getTodaysDate();
    document.getElementById("endDate").value = getTodaysDate();

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
}
function showPatientDetails() {
    var entryId = document.getElementById("entryNames").value;

    if (entryId != 0) {
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

            var endDateInput = document.getElementById("endDate");
            endDateInput.value = dto.ledgerEntry.endDate;
            populateBillings(entryId);
        });
    } else if (entryId == 0) {
        showEntryDetailInputs(true);
        document.getElementById("initials").value = "";
        document.getElementById("age").value = "";
        document.getElementById("startDate").value = getTodaysDate();
        document.getElementById("endDate").value = getTodaysDate();
    }
}
function populateBillings(entryId) {
    // fetch all billings for this entry
    // for loop to load each billing into its own div
    // create checkboxes that can only be checked IF not loaded as checked.
    fetch('./billings/' + entryId, {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(dto => {
        var billingsDiv = document.getElementById("billings");
        for (i in dto.billings) {
            var billingDiv = document.createElement("div");
            billingDiv.id = "billing_" + dto.billings[i].id;

            var billingCategoryAndType = document.createElement("h3");
            billingCategoryAndType.innerHTML = dto.categoryMap[dto.billings[i].categoryId] + ": " + dto.billingTypeMap[dto.billings[i].billingTypeId];
            billingDiv.appendChild(billingCategoryAndType);

            var billingDate = document.createElement("p");
            billingDate.innerHTML = dto.billings[i].serviceDate;
            billingDiv.appendChild(billingDate);

            var checkboxesDiv = document.createElement("div");
            checkboxesDiv.id = "checkboxes_" + dto.billings[i].id;

            var billedInput = document.createElement("input");
            billedInput.type = "checkbox";
            billedInput.id = "billed_" + dto.billings[i].id;
            billedInput.name = "billed_" + dto.billings[i].id;
            billedInput.disabled = (dto.billings[i].billed);
            checkboxesDiv.appendChild(billedInput);
            var billedLabel = document.createElement("label");
            billedLabel.htmlFor = "billed_" + dto.billings[i].id;
            billedLabel.innerHTML = "&nbsp;Billed&nbsp;&nbsp;&nbsp;&nbsp;";
            checkboxesDiv.appendChild(billedLabel);

            var completedInput = document.createElement("input");
            completedInput.type = "checkbox";
            completedInput.id = "reportComplete_" + dto.billings[i].id;
            completedInput.name = "reportComplete_" + dto.billings[i].id;
            completedInput.disabled = (dto.billings[i].reportComplete);
            checkboxesDiv.appendChild(completedInput);
            var completedLabel = document.createElement("label");
            completedLabel.htmlFor = "reportComplete_" + dto.billings[i].id;
            completedLabel.innerHTML = "&nbsp;Report Complete";
            checkboxesDiv.appendChild(completedLabel);

            billingDiv.appendChild(checkboxesDiv);

            billingsDiv.appendChild(billingDiv);
        }
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
function uncheckAllCategorySelections() {
    var selectedCategory = document.querySelector('input[name="newCategorySelection"]:checked');
    if (selectedCategory != null) {
        document.querySelector('input[name="newCategorySelection"]:checked').checked = false;
    }
}
function resetNewBillingForm() {
    uncheckAllCategorySelections();
    hideAllBillingTypeLists();
    document.getElementById("newBillingDate").value = '';
    document.getElementById("newBilledCheckbox").checked = false;
    document.getElementById("newReportCompleteCheckbox").checked = false;
}
function setNewBillingDateToToday() {
    document.getElementById("newBillingDate").value = getTodaysDate();
}
function getTodaysDate() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    return today;
}
</script>