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
<body onload="populateEntrySelection()">

  <br>
  <div class="container" >

    <div id="entrySelectionContainer" onchange="showPatientDetails();">
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

    <div id="billings">
        <div id="newBilling_1">
          <input type="radio" id="billingCategory_1" name="billingCategory" value="1">
          <label for="billingCategory_1">Office</label>&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" id="billingCategory_2" name="billingCategory" value="2">
          <label for="billingCategory_2">Hospital</label>&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" id="billingCategory_3" name="billingCategory" value="3">
          <label for="billingCategory_3">Procedure</label>
        </div>
    </div>

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
        });
    } else if (entryId == 0) {
        showEntryDetailInputs(true);
        document.getElementById("initials").value = "";
        document.getElementById("age").value = "";
        document.getElementById("startDate").value = getTodaysDate();
        document.getElementById("endDate").value = getTodaysDate();
    }
}
function showEntryDetailInputs(show) {
    document.getElementById("initials").disabled = !show;
    document.getElementById("age").disabled = !show;
    document.getElementById("startDate").disabled = !show;
}
function getTodaysDate() {
    var now = new Date();
    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);
    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    return today;
}
</script>