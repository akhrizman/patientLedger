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
  <div class="container" id="entrySelectionContainer" onclick="" onchange="showPatientDetails();">
    <select id="entryNames">
      <option value = 0>Select Entry</option>
    </select>

    <div id="entryDetails">
      <br>

      <div>
        <label for="initials">Initials</label>
        <input type="text" id="initials" name="initials">

        <label for="age">Age</label>
        <input type="select" id="age" name="age">
      </div><br>

      <label class="fieldLabels" for="startDate">Start Date</label>
      <input type="date" class="fieldInputs" id="startDate" name="startDate"><br><br>

      <label class="fieldLabels" for="endDate">End Date</label>
      <input type="date" class="fieldInputs" id="endDate" name="endDate"><br><br>
    </div>

  </div>

</body>
</html>

<script>
function populateEntrySelection() {
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

    if (entryId == 0) {
        hideAll();
        return;
    }

    fetch('./ledgerEntry/' + entryId, {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(dto => {
        console.log(dto);
        document.getElementById("entryDetails").style.display = "inline-block";

        var initialsInput = document.getElementById("initials");
        initialsInput.value = dto.ledgerEntry.initials;
        initialsInput.disabled = true;

        var ageInput = document.getElementById("age");
        ageInput.value = dto.ledgerEntry.age;
        ageInput.disabled = true;

        var startDateInput = document.getElementById("startDate");
        startDateInput.value = dto.ledgerEntry.startDate;
        startDateInput.disabled = true;

        var endDateInput = document.getElementById("endDate");
        endDateInput.value = dto.ledgerEntry.endDate;
        ageInput.disabled = true;
    });
}
function hideAll() {
    document.getElementById("initials").style.hidden = false;
    document.getElementById("age").style.hidden = false;
    document.getElementById("startDate").style.hidden = false;
    document.getElementById("endDate").style.hidden = false;
    document.getElementById("entryDetails").style.display = "none";
}
</script>