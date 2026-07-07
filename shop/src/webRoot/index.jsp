<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="lhl.hhu.ShopClientBean" %>
<jsp:useBean id="client" class="lhl.hhu.ShopClientBean" scope="request" />
<html>
    <head>
        <meta charset="UTF-8" />
        <title>shop</title>
        <script>
        function isDigit(s) {
            // 这个函数用来判定输入的信息必须为数字，使用JavaScript编写。
            var patrn = /[0-9]{1,20}$/;
            if (!patrn.exec(s)) alert("这里必须输入数字!");
        }
        </script>
    </head>
    <body>
    <form action="shopService" method="post">
        您需要点的饮料是:<input type="text" name="product" value="<jsp:getProperty name='client' property='product'/>" /><br />
        您需要给饮料加的配料是:<input type="text" name="decorator" value="<jsp:getProperty name='client' property='decorator'/>" /><br />
        配料可以加多份(不填默认为1份):<input type="text" name="num" value="1" onfocusout="isDigit(this.value)" /><br />
        <input type="submit" value="提交" /><input type="reset" value="重置" /><br />
        您所点的饮料和配料是:<jsp:getProperty name='client' property='description' /><br />
        您所点的所有饮料价格是:<jsp:getProperty name='client' property='price' />
    </form>
    </body>
</html>
