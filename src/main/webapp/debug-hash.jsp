<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="at.favre.lib.crypto.bcrypt.BCrypt" %>
<%
    String password = "123456";
    String hash = BCrypt.withDefaults().hashToString(10, password.toCharArray());
    boolean verify = BCrypt.verifyer().verify(password.toCharArray(), hash).verified;
    
    // Test hash cũ trong DB
    String oldHash = "$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lh3y";
    boolean oldVerify = BCrypt.verifyer().verify(password.toCharArray(), oldHash).verified;
%>
<h2>BCrypt Debug</h2>
<p>Password: <%= password %></p>
<p><b>New hash:</b> <%= hash %></p>
<p><b>New hash verify:</b> <%= verify %></p>
<hr>
<p><b>Old hash (in DB):</b> <%= oldHash %></p>
<p><b>Old hash verify:</b> <%= oldVerify %></p>
<hr>
<p>SQL UPDATE:<br>
<code>UPDATE tbl_persons SET password_hash = '<%= hash %>';</code></p>
