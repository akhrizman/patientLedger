<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.text.*,java.util.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Ledger</title>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.22/css/dataTables.bootstrap4.min.css">
    <script src="https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.22/js/dataTables.bootstrap4.min.js"></script>

    <link href="./css/ledgerPage.css" rel="stylesheet" type="text/css">
    <link rel="shortcut icon" type="image/png" href="./img/ledger.png">
</head>

<body onload="setDefaultDates(),populateLedger();">

  <br>
  <div class="container" >

    <div>
      <button id="btnBack" class="btn btn-primary" onclick="window.location.href='./';">BACK</button><br>
    </div><br>

    <div class="dateInput">
      <label class="fieldLabels" for="serviceDateFrom">FROM:</label>
      <input type="date" class="fieldInputs" id="serviceDateFrom" name="serviceDateFrom" onchange="populateLedger()">
    </div>
    <div class="dateInput">
      <label class="fieldLabels" for="serviceDateTo">TO:</label>
      <input type="date" class="fieldInputs" id="serviceDateTo" name="serviceDateTo" onchange="populateLedger()"><br>
    </div>

    <h2></h2>
      <table class="table table-striped table-hover table-sm table-bordered table-responsive" id="ledgerTable">
        <thead>
          <tr>
            <th scope="col">Service&nbsp;Date</th>
            <th scope="col">Initials</th>
            <th scope="col">Age</th>
            <th scope="col">Billed</th>
            <th scope="col">Reported</th>
            <th scope="col">Category</th>
            <th scope="col">Type</th>
            <th scope="col">Edit&nbsp;Billings&nbsp;&nbsp;</th>
          </tr>
        </thead>
        <tbody id="billings">
        </tbody>
      </table>
  </div>

  <div class="billingUpdatePopup">
    <div class="formPopup" id="popupForm">
      <form action="" class="formContainer" id="billingUpdateForm">
        <h2>Update Billing</h2>

        <input id="formBillingId" name="formBillingId" type="hidden">

        <select name="category" id="category"></select><br><br>
        <select name="billingType" id="billingType"></select><br><br>

        <label class="fieldLabels" for="serviceDate">Bill Date</label>
        <input type="date" class="fieldInputs" id="serviceDate" name="serviceDate"><br><br>

        <input type="checkbox" id="billedCheckbox" name="billedCheckbox">
        <label for="billedCheckbox">Billed&nbsp;&nbsp;&nbsp;</label>

        <input type="checkbox" id="reportCompleteCheckbox" name="reportCompleteCheckbox">
        <label for="reportCompleteCheckbox">Reported</label>

        <button type="submit" class="btn" onclick="updateBilling()">Update Billing</button>
        <button type="button" class="btn cancel" onclick="closeForm()">Close</button>
      </form>
    </div>
  </div>

</body>
</html>


<script>
function populateLedger() {
    if ($('#ledgerTable').dataTable() != null) {
        $('#ledgerTable').dataTable().fnDestroy();
    }
    var billingRows = document.getElementById("billings");
    billingRows.innerHTML = '';

    var startDateString = document.getElementById("serviceDateFrom").value;
    var endDateString = document.getElementById("serviceDateTo").value;

    var params = new Object();
    if (startDateString != '') {
        params.startDate = getDateForSubmission(startDateString);
    }
    if (endDateString != '') {
        params.endDate = getDateForSubmission(endDateString);
    }

    fetch('./billings?' + new URLSearchParams(params), {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(billings => {
        var ledgerTable = document.getElementById("ledgerTable");

        for (i in billings) {
            let billingRow = document.createElement("tr");
            billingRow.id = billings[i].billingId;

            let serviceDate = document.createElement("td");
            serviceDate.innerHTML = billings[i].serviceDate;
            billingRow.appendChild(serviceDate);

            let initials = document.createElement("td");
            initials.innerHTML = billings[i].initials;
            billingRow.appendChild(initials);

            let age = document.createElement("td");
            age.innerHTML = billings[i].age;
            billingRow.appendChild(age);

            let billed = document.createElement("td");
            if (billings[i].billed) {
                billed.innerHTML = "YES";
            } else {
                billed.innerHTML = "NO";
                billed.style.background = "red";
            }
            billingRow.appendChild(billed);

            let reportComplete = document.createElement("td");
            if (billings[i].reportComplete) {
                reportComplete.innerHTML = "YES";
            } else {
                reportComplete.innerHTML = "NO";
                reportComplete.style.background = "orange";
            }
            billingRow.appendChild(reportComplete);

            let category = document.createElement("td");
            category.innerHTML = billings[i].category;
            billingRow.appendChild(category);

            let billingType = document.createElement("td");
            billingType.innerHTML = billings[i].billingType;
            billingRow.appendChild(billingType);

            let billingUpdateCell = document.createElement("td");
            billingUpdateCell.innerHTML =
            "<button type='button' onclick='openBillingEditPopup(this);' class='btn btn-default btn-sm' id='btnOpenBillingEditPopup'>" +
                    "<span class='glyphicon glyphicon-pencil' />" +
                    "</button>&nbsp;" +
            "<button type='button' onclick='deleteBilling(this);' class='btn btn-default btn-sm'>" +
                    "<span class='glyphicon glyphicon-trash' />" +
                    "</button>";
            billingRow.appendChild(billingUpdateCell);

            billingRows.appendChild(billingRow);
        }

        $('#ledgerTable').DataTable( {
            'columnDefs': [ {
               'targets': [7], /* table column index */
               'orderable': false
        }],
            'aLengthMenu': [[10, 50, -1], [10, 50, "All"]],
            'pageLength': 10,
            'dom': 'iftlp'
        });
    });
}
function deleteBilling(button) {
    var billingId = $(button).parents("tr").attr('id');
    var originalColor = document.getElementById(billingId).style.background;
    document.getElementById(billingId).style.background = "red";
    if (!confirm("Are you Sure? This cannot be undone.")) {
        document.getElementById(billingId).style.background = originalColor;
        return;
    }
    fetch('./billing/'+billingId, {
        method: 'DELETE',
        headers: {'Content-type': 'application/json'}
    })
    .then( response => {
        if (response.status === 200) {
            console.log("SUCCESSS");
            $(button).parents("tr").remove();
        } else {
            console.log("SOMETHING WENT WRONG");
            document.getElementById(billingId).style.background = originalColor;
        }
    });
}
function openBillingEditPopup(button) {
    var billingId = $(button).parents("tr").attr('id');
    document.getElementById("popupForm").style.display = "block";
    formBillingId = document.getElementById("formBillingId");
    formBillingId.value = billingId;

    fetch('./billing/'+billingId, {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(ledgerEntryDetailsDto => {
        console.log(ledgerEntryDetailsDto);
        var billing = ledgerEntryDetailsDto.billings[0];
        var categoryMap = ledgerEntryDetailsDto.categoryMap;
        var billingTypeMap = ledgerEntryDetailsDto.billingTypeMap;

        var categoryDropdown = document.getElementById("category");
        var billingTypeDropdown = document.getElementById("billingType");

        if (!categoryDropdown.hasChildNodes() && !billingTypeDropdown.hasChildNodes()) {
            for (var categoryId in categoryMap) {
                var categoryOption = document.createElement("option");
                categoryOption.value = categoryId;
                categoryOption.innerHTML = categoryMap[categoryId];
                if (billing.categoryId == categoryId) {
                    console.log("categoryOption.selected: " + categoryOption.selected);
                    categoryOption.selected = true;
                    console.log("categoryOption.selected: " + categoryOption.selected);
                }
                categoryDropdown.appendChild(categoryOption);
            }

            for (var billingTypeId in billingTypeMap) {
                var billingTypeOption = document.createElement("option");
                billingTypeOption.value = billingTypeId;
                billingTypeOption.innerHTML = billingTypeMap[billingTypeId];
                if (billing.billingTypeId == billingTypeId) {
                    console.log("billingTypeOption.selected: " + billingTypeOption.selected);
                    billingTypeOption.selected = true;
                    console.log("billingTypeOption.selected: " + billingTypeOption.selected);
                }
                billingTypeDropdown.appendChild(billingTypeOption);
            }
        }

        categoryField = document.getElementById("category");
        typeField = document.getElementById("billingType");
        serviceDateField = document.getElementById("serviceDate");
        billedCheckbox = document.getElementById("billedCheckbox");
        reportCompleteCheckbox = document.getElementById("reportCompleteCheckbox");

        categoryField.value = ledgerEntryDetailsDto.categoryMap[billing.categoryId];
        typeField.value = ledgerEntryDetailsDto.billingTypeMap[billing.billingTypeId];
        serviceDateField.value = billing.serviceDate;
        billedCheckbox.checked = billing.billed;
        reportCompleteCheckbox.checked = billing.reportComplete;
    });

}
function updateBilling() {
    categoryField = document.getElementById("category");
    typeField = document.getElementById("billingType");
    serviceDateField = document.getElementById("serviceDate");
    billedCheckbox = document.getElementById("billedCheckbox");
    reportCompleteCheckbox = document.getElementById("reportCompleteCheckbox");
    billingId = document.getElementById("formBillingId").value;

    var billing = {
        id: billingId,
        categoryId: 1, // set this to the value of the dropdown selection
        billingTypeId: 1, // set this to the value of the dropdown selection
        serviceDate: getDateForSubmission(serviceDateField.value),
        billed: billedCheckbox.checked,
        reportComplete: reportCompleteCheckbox.checked
    };
    console.log("billing: " + billing);

    fetch("./billing", {
        method: "PUT",
        body: JSON.stringify(billing),
        headers: {'Content-type': 'application/json'}
        })
    .then(response => response.json())
    .then(billing => {
        console.log("billing: " + JSON.stringify(billing));
    });
    //window.location.reload(true);
}
function closeForm() {
  document.getElementById("popupForm").style.display = "none";
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
function setDefaultDates() {
    document.getElementById("serviceDateFrom").value = getFirstDayOfPreviousMonth();
    document.getElementById("serviceDateTo").value = getLastDayOfCurrentMonth();
}
function getFirstDayOfCurrentMonth() {
    var date = new Date();
    var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
    var day = ("0" + firstDay.getDate()).slice(-2);
    var month = ("0" + (firstDay.getMonth() + 1)).slice(-2);
    return firstDay.getFullYear()+"-"+(month)+"-"+(day);
}
function getLastDayOfCurrentMonth() {
    var date = new Date();
    var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
    var day = ("0" + lastDay.getDate()).slice(-2);
    var month = ("0" + (lastDay.getMonth() + 1)).slice(-2);
    return lastDay.getFullYear()+"-"+(month)+"-"+(day);
}
function getFirstDayOfPreviousMonth() {
    var date = new Date();
    date.setDate(0);
    var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
    var day = ("0" + firstDay.getDate()).slice(-2);
    var month = ("0" + (firstDay.getMonth() + 1)).slice(-2);
    return firstDay.getFullYear()+"-"+(month)+"-"+(day);
}
</script>