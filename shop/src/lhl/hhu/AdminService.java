package lhl.hhu;

import java.io.IOException;
import java.util.Map;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AdminService extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InventoryManager inventory = InventoryManager.getInstance();
        request.setAttribute("stock", inventory.getStock());
        request.setAttribute("sold", inventory.getSold());
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
        dispatcher.forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        InventoryManager inventory = InventoryManager.getInstance();
        String message = "";

        try {
            if ("restock".equals(action)) {
                String item = request.getParameter("item");
                String amountStr = request.getParameter("amount");
                int amount = 10; // 默认补货10份
                if (amountStr != null && !amountStr.trim().equals("")) {
                    amount = Integer.parseInt(amountStr.trim());
                }
                if (amount < 1) amount = 10;
                inventory.restock(item, amount);
                message = item + " 补货成功，+" + amount + " 份！";
            }
        } catch (Exception e) {
            message = "操作失败，请重试。";
        }

        request.setAttribute("stock", inventory.getStock());
        request.setAttribute("sold", inventory.getSold());
        request.setAttribute("message", message);
        RequestDispatcher dispatcher = request.getRequestDispatcher("admin.jsp");
        dispatcher.forward(request, response);
    }
}
