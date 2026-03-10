<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Record</title>
    <style>
        body { font-family: sans-serif; background-color: #f9f9f9; padding: 20px; }
        form { background: white; padding: 20px; border: 1px solid #ccc; display: inline-block; margin-top: 10px; }
        td { padding: 5px; }
        input[type="submit"] { background-color: #28a745; color: white; border: none; padding: 10px 20px; cursor: pointer; font-weight: bold; margin-top: 10px; }
        input[type="submit"]:hover { background-color: #218838; }
        a { color: #007bff; text-decoration: none; font-weight: bold; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <a href="index.jsp">[ Back to Home ]</a>
    <h2>New Entry</h2>

    <form action="students" method="POST">
        <table>
            <tr>
                <td>Car Name</td>
                <td><input type="text" name="Carname" required></td>
            </tr>
            <tr>
                <td>Start Date:</td>
                <td><input type="date" name="StartDate" required></td>
            </tr>
            <tr>
                <td>Return Date :</td>
                <td><input type="date" name="ReturnDate" required></td>
            </tr>
            <tr>
                <td> Amount :</td>
                <td><input type="number" name="Amount" required></td>
            </tr>
            <tr>
                <td> Statuss  :</td>
                <td><input type="text" name="Statuss" required></td>
            </tr>
          
            <tr>
                <td colspan="2"><input type="submit" value="Add Record"></td>
            </tr>
        </table>
    </form>
    <a href="students?action=ls">View records</a>
</body>
</html>
