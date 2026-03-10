<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Budget List</title>
    <style>
        body { font-family: sans-serif; background-color: #f9f9f9; padding: 20px; }
        table { border-collapse: collapse; width: 100%; background: white; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #eee; }
        a { color: #007bff; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <a href="index.jsp">[ Home ]</a> | <a href="students?action=add">[ Add New ]</a>
    <h2>Budget Records</h2>

    <table border="1">
        <thead>
            <tr>
                <th>Car ID:</th>
                <th>Car Name</th>
                <th>Start Date </th>
                <th>Return Date</th>
                 <th>Amount </th>
                  <th>Status </th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="s" items="${students}">
                <tr>
                    <td>${s.carID}</td>
                    <td>${s.carname}</td>
                    <td>${s.startDate}</td>
                    <td>${s.returnDate}</td>
                    <td>${s.amount}</td>
                     <td>${s.statuss}</td>
                    
                    
                   
                </tr>
            </c:forEach>
            <c:if test="${empty students}">
                <tr>
                    <td colspan="5">No records found.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
