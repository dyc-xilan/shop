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
        .actions input { flex: 1; cursor: pointer; }
        .actions input[type="button"] {
            background: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #a5d6a7;
            padding: 10px;
            border-radius: 8px;
            font-weight: normal;
        }
        .actions input[type="button"]:hover {
            background: #c8e6c9;
        }
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
        .hint {
            color: #e65100;
            font-weight: bold;
            margin-top: 4px;
        }
        .toast {
            display: inline-block;
            background: #ff9800;
            color: #fff;
            padding: 6px 12px;
            border-radius: 6px;
            font-weight: bold;
            font-size: 12px;
            margin-top: 4px;
            animation: toastIn 0.3s ease;
            pointer-events: none;
        }
        @keyframes toastIn {
            from { opacity: 0; transform: translateY(-6px); }
            to   { opacity: 1; transform: translateY(0); }
        }
    </style>
    <script>
        var initialLoad = true;
        function showToast(id, msg) {
            var old = document.getElementById(id);
            if (old) old.remove();
            var div = document.createElement('div');
            div.id = id;
            div.className = 'toast';
            div.textContent = msg;
            var numInput = document.getElementById('num');
            numInput.insertAdjacentElement('afterend', div);
        }
        function hideToast(id) {
            var t = document.getElementById(id);
            if (t) t.remove();
        }

        function isDigit(s) {
            if (!/^[0-9]{1,20}$/.test(s)) {
                showToast('toast-digit', '这里必须输入数字！');
            }
        }

        function updatePreview() {
            var beveragePrice = 0;
            var decoratorPrice = 0;
            var rawVal = document.getElementById('num').value;
            var count = Number(rawVal || 1);
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

            // 数字格式校验
            var digitOk = /^[0-9]{1,20}$/.test(rawVal);
            if (!digitOk) {
                if (!initialLoad) {
                    showToast('toast-digit', '这里必须输入数字！');
                }
            } else {
                hideToast('toast-digit');
            }

            // 数量上限校验
            if (digitOk && count > 5) {
                count = 5;
                document.getElementById('num').value = 5;
                if (!initialLoad) {
                    showToast('toast-limit', '配料份数不得超过5份，已自动设为5份');
                }
            } else {
                hideToast('toast-limit');
            }

            if (count < 1 || isNaN(count)) {
                count = 1;
                document.getElementById('num').value = 1;
            }

            var total = beveragePrice + decoratorPrice * count;
            document.getElementById('previewPrice').textContent = '预估总价：' + total.toFixed(2) + ' 元';
        }

        function doReset() {
            document.getElementById('product').selectedIndex = 0;
            document.getElementById('decorator').selectedIndex = 0;
            document.getElementById('num').value = 1;
            document.getElementById('previewPrice').textContent = '预估总价：0.00 元';
            document.getElementById('currentDesc').textContent = '您还没有点饮料。';
            document.getElementById('submittedPrice').textContent = '0.00';
            hideToast('toast-digit');
            hideToast('toast-limit');
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
                <input type="button" value="重置" onclick="doReset()" />
            </div>

            <div class="summary">
                <div id="previewPrice" class="price">预估总价：0.00 元</div>
                <div>您当前选择：<span id="currentDesc"><jsp:getProperty name="client" property="description" /></span></div>
                <div>已提交价格：<span id="submittedPrice"><jsp:getProperty name="client" property="price" /></span> 元</div>
            </div>
        </form>
    </div>
    <script>updatePreview(); initialLoad = false;</script>
</body>
</html>
