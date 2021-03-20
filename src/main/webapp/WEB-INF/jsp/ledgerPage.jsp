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
<body onload="populateLedger();">

  <br>
  <div class="container" >

  <div>
    <button id="btnBack" class="btn btn-primary" onclick="window.location.href='./';">BACK</button><br>
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
        </tr>
      </thead>
      <tbody>
      </tbody>
    </table>
  </div>

</body>
</html>

<script>
function populateLedger() {
    fetch('./billingEntries', {
        method: 'GET',
        headers: {'Content-type': 'application/json'}
    })
    .then(response => response.json())
    .then(billings => {
        var ledgerTable = document.getElementById("ledgerTable");
        for (i in billings) {
            var billingRow = document.createElement("tr");
            billingRow.id = "billingId_"+billings[i].billingId;

            var serviceDate = document.createElement("td");
            serviceDate.innerHTML = billings[i].serviceDate;
            billingRow.appendChild(serviceDate);

            var patient = document.createElement("td");
            patient.innerHTML = billings[i].initials + "-" + billings[i].age;
            billingRow.appendChild(patient);

            var billed = document.createElement("td");
            if (billings[i].billed) {
                billed.innerHTML = "YES";
            } else {
                billed.innerHTML = "NO";
                billed.style.background = "red";
            }
            billingRow.appendChild(billed);

            var reportComplete = document.createElement("td");
            if (billings[i].reportComplete) {
                reportComplete.innerHTML = "YES";
            } else {
                reportComplete.innerHTML = "NO";
                reportComplete.style.background = "orange";
            }
            billingRow.appendChild(reportComplete);

            var category = document.createElement("td");
            category.innerHTML = billings[i].category;
            billingRow.appendChild(category);

            var billingType = document.createElement("td");
            billingType.innerHTML = billings[i].billingType;
            billingRow.appendChild(billingType);

            ledgerTable.appendChild(billingRow);
        }
    });
}


</script>