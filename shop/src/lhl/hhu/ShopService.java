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
        //参数定义
        String product;
        String decorator;
        String num;
        String description="";
        double price;
        int number=1;
        //建立模型对象bean
        ShopClientBean bean = new ShopClientBean();
        request.setAttribute("client", bean);
        //创建工厂
        Beverage beverage = null;
        BeverageFactory factory = new BeverageFactory();
        DecoratorFactory deco = new DecoratorFactory();
        //获取页面参数
        product = request.getParameter("product").trim();
        decorator = request.getParameter("decorator").trim();
        num = request.getParameter("num").trim();
        if(num != null && !num.equals(""))
            number = Integer.parseInt(num);
        if(product != null && !product.equals("")){
            //获取基础饮料
            beverage = factory.getBeverage(product);
            description = beverage.getDescription();
            //合法饮料且存在配料，叠加多份配料
            if(!(beverage instanceof NoBeverage) && !decorator.equals("") && number!=0){
                beverage = deco.getDecorator(decorator, beverage);
                if(beverage instanceof NoDecorator)
                    description = beverage.getDescription();
                else{
                    description = beverage.getDescription()+" "+number+"份";
                    //循环叠加多份配料
                    for(int i=1;i<number;i++){
                        beverage = deco.getDecorator(decorator, beverage);
                    }
                }
            }
            price = beverage.getCost();
            //数据存入模型
            bean.setProduct(product);
            bean.setDecorator(decorator);
            bean.setDescription(description);
            bean.setPrice(price);
        }
        //页面跳转
        RequestDispatcher dispatcher = request.getRequestDispatcher("index.jsp");
        dispatcher.forward(request, response);
    }
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException{
        doPost(request,response);
    }
}
