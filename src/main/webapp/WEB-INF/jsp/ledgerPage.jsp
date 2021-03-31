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
    <link href="./css/ledgerPage.css" rel="stylesheet" type="text/css">
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
    <table class="table" id="ledgerTable">
      <thead>
        <tr>
          <th>Service Date</th>
          <th>Patient</th>
          <th>Billed</th>
          <th>Reported</th>
          <th>Category</th>
          <th>Type</th>
          <th></th>
        </tr>
      </thead>
    </table>
  </div>

</body>
</html>

<script>
function populateLedger() {
    $('#ledgerTable tbody').empty();
    var startDateString = document.getElementById("serviceDateFrom").value;
    var endDateString = document.getElementById("serviceDateTo").value;
    //if (startDateString == '') { startDateString = null; }
    //if (endDateString == '') { endDateString = null; }
    fetch('./billings?' + new URLSearchParams({
            startDate: (startDateString == '') ? getDateForSubmission('2000-01-01') : getDateForSubmission(startDateString),
            endDate: (endDateString == '') ? getDateForSubmission('2099-01-01') : getDateForSubmission(endDateString)
        }), {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(billings => {
        var ledgerTable = document.getElementById("ledgerTable");
        var tableBody = document.createElement("tbody")
        for (i in billings) {
            let billingRow = document.createElement("tr");
            billingRow.id = billings[i].billingId;

            let serviceDate = document.createElement("td");
            serviceDate.innerHTML = billings[i].serviceDate;
            billingRow.appendChild(serviceDate);

            let patient = document.createElement("td");
            patient.innerHTML = billings[i].initials + "-" + billings[i].age;
            billingRow.appendChild(patient);

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

            let trashButtonCell = document.createElement("td");
            trashButtonCell.innerHTML =
            "<button type='button' onclick='enableBillingEditing(this);' class='btn btn-default btn-sm' id='btnEnableBillingEditing'>" +
                    "<span class='glyphicon glyphicon-pencil' />" +
                    "</button>&nbsp;" +
            "<button type='button' onclick='saveBilling(this);' class='btn btn-default btn-sm' id='btnSaveBilling'>" +
                    "<span class='glyphicon glyphicon-save' />" +
                    "</button>&nbsp;" +
            "<button type='button' onclick='deleteBilling(this);' class='btn btn-default btn-sm'>" +
                    "<span class='glyphicon glyphicon-trash' />" +
                    "</button>";
            billingRow.appendChild(trashButtonCell);

            tableBody.appendChild(billingRow);
        }
        ledgerTable.appendChild(tableBody);
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
function enableBillingEditing(button) {
    document.getElementById("btnEnableBillingEditing").style.display = "none";
    document.getElementById("btnSaveBilling").style.display = "inline-block";
    // change cell text to date picker input and default with the original values.
    // change cell billed & reported to check boxes
}
function saveBilling(button) {
    document.getElementById("btnEnableBillingEditing").style.display = "inline-block";
    document.getElementById("btnSaveBilling").style.display = "none";
    // fetch the update
    // reload the page
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