<%@ page language="java" pageEncoding="UTF-8"%> 
<%@ page contentType="text/html; charset=UTF-8"%> 
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.DecimalFormat"%>
    
<%
String db_usr = "root";
String db_psw = "123456";   
String connectionURL = "jdbc:mysql://127.0.0.1:3306";
Connection conn = null; 
try{
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    conn = DriverManager.getConnection(connectionURL, db_usr, db_psw);
    Statement state = conn.createStatement();
    String sql_orderinfo = 
        "SELECT DISTINCT(species) FROM CMPE272.final_with_full_name ORDER BY species";
    
    ResultSet rset_oi = state.executeQuery(sql_orderinfo);
    while(rset_oi.next()){
    %>
<li data-value="<%=rset_oi.getString(1) %>" data-name="<%=rset_oi.getString(1) %>" 
data-filtertext="<%=rset_oi.getString(1).subSequence(0,1) %>" style="vertical-align:middle;"><a href='#p2'>
<%=rset_oi.getString(1) %>
</a></li>
    <%
    }
} catch(Exception e){
    e.printStackTrace();    
} finally {
    conn.close();
}
%>