<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="client" class="lhl.hhu.ShopClientBean" scope="request" />
<html>
<head>
    <meta charset="UTF-8" />
    <title>饮品定制系统</title>
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
            width: 460px;
            background: white;
            padding: 28px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        }
        h2 { text-align: center; color: #2e7d32; margin-top: 0; }
        label { display: block; margin: 12px 0 6px; font-weight: bold; color: #33691e; }
        select, input[type="number"], input[type="submit"], input[type="reset"] {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #a5d6a7;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background: #43a047;
            color: white;
            border: none;
            font-weight: bold;
        }
        input[type="submit"]:hover {
            background: #2e7d32;
        }
        input[type="reset"] {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
        }
        input[type="reset"]:hover {
            background: #c8e6c9;
        }
        .actions { display: flex; gap: 10px; margin-top: 12px; }
        .actions input { cursor: pointer; }
        .summary {
            margin-top: 16px;
            padding: 12px;
            background: #e8f5e9;
            border-radius: 8px;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }
        .price {
            font-size: 20px;
            font-weight: bold;
            color: #1b5e20;
        }
    </style>
    <script>
        function isDigit(s) {
            var patrn = /[0-9]{1,20}$/;
            if (!patrn.exec(s)) {
                alert("这里必须输入数字!");
            }
        }

        function updatePreview() {
            var beveragePrice = 0;
            var decoratorPrice = 0;
            var count = Number(document.getElementById('num').value || 1);
            var beverage = document.getElementById('product').value;
            var decorator = document.getElementById('decorator').value;

            if (beverage === 'coca') {
                beveragePrice = 1;
            } else if (beverage === 'coffee') {
                beveragePrice = 2;
            }

            if (decorator === 'milk') {
                decoratorPrice = 0.5;
            } else if (decorator === 'ice') {
                decoratorPrice = 0.5;
            }

            var total = beveragePrice + decoratorPrice * count;
            document.getElementById('previewPrice').textContent = '预估总价：' + total.toFixed(2) + ' 元';
        }
    </script>
</head>
<body>
    <div class="card">
        <h2>饮品定制系统</h2>
        <form action="shopService" method="post">
            <label for="product">请选择饮料</label>
            <select id="product" name="product" onchange="updatePreview()">
                <option value="">-- 请选择 --</option>
                <option value="coca">coca</option>
                <option value="coffee">coffee</option>
            </select>

            <label for="decorator">请选择配料</label>
            <select id="decorator" name="decorator" onchange="updatePreview()">
                <option value="">-- 请选择 --</option>
                <option value="milk">milk</option>
                <option value="ice">ice</option>
            </select>

            <label for="num">配料份数</label>
            <input type="number" id="num" name="num" min="1" max="10" value="1" oninput="isDigit(this.value); updatePreview();" />

            <div class="actions">
                <input type="submit" value="提交订单" />
                <input type="reset" value="重置" />
            </div>

            <div class="summary">
                <div id="previewPrice" class="price">预估总价：0.00 元</div>
                <div>您当前选择：<jsp:getProperty name="client" property="description" /></div>
                <div>已提交价格：<jsp:getProperty name="client" property="price" /> 元</div>
            </div>
        </form>
    </div>
    <script>updatePreview();</script>
</body>
</html>
