<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, Integer> stock = (Map<String, Integer>) request.getAttribute("stock");
    Map<String, Integer> sold  = (Map<String, Integer>) request.getAttribute("sold");
    String message = (String) request.getAttribute("message");
%>
<html>
<head>
    <meta charset="UTF-8" />
    <title>后台管理看板</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: linear-gradient(135deg, #c8e6c9, #e8f5e9);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .card {
            width: 560px;
            background: white;
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        h2 { text-align: center; color: #2e7d32; margin-top: 0; }
        .nav { text-align: center; margin-bottom: 16px; }
        .nav a { color: #43a047; text-decoration: none; font-weight: bold; }
        .nav a:hover { text-decoration: underline; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 12px 0;
        }
        th, td {
            padding: 10px;
            text-align: center;
            border-bottom: 1px solid #c8e6c9;
        }
        th { background: #e8f5e9; color: #2e7d32; }
        td { color: #333; }
        .low-stock { color: #e65100; font-weight: bold; }
        .ok-stock { color: #2e7d32; }
        .actions { display: flex; gap: 8px; justify-content: center; align-items: center; }
        .actions input[type="number"] {
            width: 60px;
            padding: 6px;
            border-radius: 6px;
            border: 1px solid #a5d6a7;
            text-align: center;
        }
        .actions input[type="submit"] {
            padding: 6px 14px;
            border: none;
            border-radius: 6px;
            background: #43a047;
            color: white;
            font-weight: bold;
            cursor: pointer;
        }
        .actions input[type="submit"]:hover { background: #2e7d32; }
        .msg {
            text-align: center;
            padding: 10px;
            margin-bottom: 12px;
            border-radius: 8px;
            font-weight: bold;
            background: #c8e6c9;
            color: #1b5e20;
        }
        .back-link { text-align: center; margin-top: 16px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>📊 后台管理看板</h2>
        <% if (message != null && !message.isEmpty()) { %>
            <div class="msg"><%= message %></div>
        <% } %>
        <table>
            <tr>
                <th>商品</th>
                <th>当前库存</th>
                <th>累计销量</th>
                <th>补货操作</th>
            </tr>
            <% if (stock != null) {
                String[] order = {"coca", "coffee", "milk", "ice"};
                for (String key : order) {
                    int s = stock.containsKey(key) ? stock.get(key) : 0;
                    int sl = sold.containsKey(key) ? sold.get(key) : 0;
            %>
            <tr>
                <td><%= key %></td>
                <td class="<%= s <= 3 ? "low-stock" : "ok-stock" %>"><%= s %></td>
                <td><%= sl %></td>
                <td>
                    <form method="post" action="adminService" style="margin:0;">
                        <input type="hidden" name="action" value="restock" />
                        <input type="hidden" name="item" value="<%= key %>" />
                        <div class="actions">
                            <input type="number" name="amount" min="1" max="100" value="10" />
                            <input type="submit" value="补货" />
                        </div>
                    </form>
                </td>
            </tr>
            <%      }
            } %>
        </table>
        <div class="back-link">
            <a href="index.jsp">← 返回前台点单</a>
        </div>
    </div>
</body>
</html>
