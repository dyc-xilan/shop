package lhl.hhu;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShopService extends HttpServlet{
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 建立模型对象bean
        ShopClientBean bean = new ShopClientBean();
        request.setAttribute("client", bean);

        try {
            // 参数定义
            String product;
            String decorator;
            String num;
            String description = "";
            double price = 0;
            int number = 1;
            // 创建工厂
            Beverage beverage = null;
            BeverageFactory factory = new BeverageFactory();
            DecoratorFactory deco = new DecoratorFactory();
            // 获取页面参数
            product = request.getParameter("product");
            decorator = request.getParameter("decorator");
            num = request.getParameter("num");
            if (product == null) product = "";
            if (decorator == null) decorator = "";
            if (num == null || num.trim().equals("")) {
                number = 1;
            } else {
                try {
                    number = Integer.parseInt(num.trim());
                } catch (NumberFormatException e) {
                    number = 1;
                }
            }
            // 二次校验：配料份数超过5份自动截断
            boolean truncated = false;
            if (number > 5) {
                number = 5;
                truncated = true;
            }
            if (number < 1) {
                number = 1;
            }
            product = product.trim();
            decorator = decorator.trim();
            if (product != null && !product.equals("")) {
                // 获取基础饮料
                beverage = factory.getBeverage(product);
                description = beverage.getDescription();
                // 合法饮料且存在配料，叠加多份配料
                if (!(beverage instanceof NoBeverage) && !decorator.equals("") && number != 0) {
                    beverage = deco.getDecorator(decorator, beverage);
                    if (beverage instanceof NoDecorator) {
                        description = beverage.getDescription();
                    } else {
                        description = beverage.getDescription() + " " + number + "份";
                        // 循环叠加多份配料
                        for (int i = 1; i < number; i++) {
                            beverage = deco.getDecorator(decorator, beverage);
                        }
                    }
                }
                price = beverage.getCost();
                // 截断提示
                if (truncated) {
                    description += "（提示：配料不得超过5份，已自动截断）";
                }
                // 数据存入模型
                bean.setProduct(product);
                bean.setDecorator(decorator);
                bean.setDescription(description);
                bean.setPrice(price);
            }
        } catch (Exception e) {
            // 捕获所有异常，杜绝500错误
            bean.setProduct("");
            bean.setDecorator("");
            bean.setDescription("系统处理出错，请重新选择。");
            bean.setPrice(0);
        }
        // 页面跳转
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        doPost(request,response);
    }
}
