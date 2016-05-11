<%@ page language="java" pageEncoding="UTF-8"%> 
<%@ page contentType="text/html; charset=UTF-8"%> 
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.DecimalFormat"%>
    
<%
String db_usr = "root";
String db_psw = "123456";   
String connectionURL = "jdbc:mysql://127.0.0.1:3306";
Connection conn = null; 
try{
    String fishType = request.getParameter("fishTypeN").toString();
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    conn = DriverManager.getConnection(connectionURL, db_usr, db_psw);
    Statement state = conn.createStatement();
    String sql_orderinfo = 
        "SELECT * FROM CMPE272.final_with_full_name WHERE species='"+fishType+"'";
    
    ResultSet rset_oi = state.executeQuery(sql_orderinfo);
    boolean isfirsttime = true;
    while(rset_oi.next()){
        if(isfirsttime){
            isfirsttime = false;
            %>{"result":[<%
        } else {
            %>,<%
        }
    %>
{"County":"<%=rset_oi.getString(2)%>", "Water":"<%=rset_oi.getString(3)%>",
"Species":"<%=rset_oi.getString(4)%>", "Season":"<%=rset_oi.getString(5)%>",
"lat":"<%=rset_oi.getString(6)%>", "lon":"<%=rset_oi.getString(7)%>"}
    <%
    }
    %>]}<%
} catch(Exception e){
    e.printStackTrace();    
} finally {
    conn.close();
}
%>