<%@ page language="java" pageEncoding="UTF-8"%> 
<%@ page contentType="text/html; charset=UTF-8"%> 
<%@ page import="java.io.*,java.util.*,java.sql.*,java.text.DecimalFormat,java.net.*,java.util.regex.Matcher,java.util.regex.Pattern" %>
    
<%
String db_usr = "root";
String db_psw = "123456";   
String connectionURL = "jdbc:mysql://127.0.0.1:3306";
Connection conn = null; 
try{
    String recv;
    String recvbuff;
    String url = "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?text=";
    String token = "PzrC_exWHUTMmajoOZih4NxNOr1KKyagiy5uORWl0MGY51kpzVHPGnakweF0ZPHAkRk_7VHNKfUIrPULkoSZJxwi4S2E2na0iMjYwEnt09xgFeSA985vGEDjKobKLRrcM12HRPS8W4f43hstID4-2w..";
    String street = request.getParameter("street").toString();
    String city = request.getParameter("city").toString();
    String state = request.getParameter("state").toString();
    String zipcode = request.getParameter("zipcode").toString();
    String allurl = url + street + ", " + city + ", " + state + ", " 
        + zipcode + "&forStorage=true&token=" + token + "&f=pjson";
    String urlcheck = allurl.replaceAll(" ", "%20");
    
    BufferedReader reader = null;
    URL urll = new URL(urlcheck);
    reader = new BufferedReader(new InputStreamReader(urll.openStream()));
    StringBuffer buffer = new StringBuffer();
    int read;
    char[] chars = new char[1024];
    while ((read = reader.read(chars)) != -1)
    {
        buffer.append(chars, 0, read);
    }
    StringBuffer sBuffer = new StringBuffer();
    Pattern p = Pattern.compile("[0-9]+.[0-9]*|[0-9]*.[0-9]+|[0-9]+");
    Matcher m = p.matcher(buffer);
    while (m.find()) {
      sBuffer.append(m.group());
    }

    int xstart = buffer.lastIndexOf("x");
    String x = buffer.substring(xstart + 4, xstart + 16);
    String y = buffer.substring(xstart + 35, xstart + 47);
    
    Double lon = Double.parseDouble(x);
    Double lat = Double.parseDouble(y);
    
    // search about 1 degree lon ~ 54 mile
    // search about 1 degree lat ~ 69 mile
    Double lonstart = lon - 0.5;
    Double lonend = lon + 0.5;
    Double latstart = lat - 0.4;
    Double latend = lat + 0.4;
  
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 
    conn = DriverManager.getConnection(connectionURL, db_usr, db_psw);
    Statement states = conn.createStatement();
    String sql_orderinfo = 
        "SELECT * FROM CMPE272.final_with_full_name WHERE (lon between " + 
            lonstart + " and " + lonend + ") and (lat between " + latstart + 
                " and " + latend + ") order by lon;";
    
    ResultSet rset_oi = states.executeQuery(sql_orderinfo);
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
"lat":"<%=rset_oi.getString(6)%>", "lon":"<%=rset_oi.getString(7)%>", 
"centerx":"<%=lon%>", "centery":"<%=lat%>"}
    <%
    }
    %>]}<%
} catch(Exception e){
    e.printStackTrace();    
} finally {
    conn.close();
}
%>