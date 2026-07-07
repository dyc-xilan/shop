<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:useBean id="client" class="lhl.hhu.ShopClientBean" scope="request" />
<html>
<head>
    <meta charset="UTF-8" />
    <title>自动生产售货机系统</title>
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
        .modal-overlay {
            position: fixed;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }
        .modal-card {
            background: white;
            padding: 36px 44px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            max-width: 400px;
            animation: popIn 0.35s ease;
        }
        @keyframes popIn {
            from { opacity: 0; transform: scale(0.7); }
            to   { opacity: 1; transform: scale(1); }
        }
        .modal-card .icon {
            font-size: 52px;
            margin-bottom: 10px;
        }
        .modal-card .msg {
            font-size: 17px;
            font-weight: bold;
            color: #333;
            line-height: 1.6;
        }
        .modal-card.success { border-top: 5px solid #43a047; }
        .modal-card.error   { border-top: 5px solid #e65100; }
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
        <h2>自动生产售货机系统</h2>
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
    <script>
        (function() {
            var desc = '<jsp:getProperty name="client" property="description" />';
            var price = parseFloat('<jsp:getProperty name="client" property="price" />') || 0;
            if (price > 0) {
                showModal('success', '&#10004; 点单成功！', desc);
            } else if (desc.indexOf('缺货') >= 0 || desc.indexOf('库存不足') >= 0) {
                showModal('error', '&#10008; 库存不足', desc);
            }
        })();

        function showModal(type, title, detail) {
            var overlay = document.createElement('div');
            overlay.className = 'modal-overlay';
            overlay.onclick = function(e) {
                if (e.target === overlay) overlay.remove();
            };
            var card = document.createElement('div');
            card.className = 'modal-card ' + type;
            card.innerHTML =
                '<div class="icon">' + (type === 'success' ? '&#127881;' : '') + '</div>' +
                '<div class="msg">' + title + '<br>' + detail + '</div>';
            overlay.appendChild(card);
            document.body.appendChild(overlay);
            setTimeout(function() { overlay.remove(); }, 1500);
        }
    </script>
</body>
</html>
