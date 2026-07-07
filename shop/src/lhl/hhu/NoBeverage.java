package lhl.hhu;
//添加这个装饰者类是为了使访问统一，处理各种非法请求
public class NoBeverage extends Beverage {
    String description = "没有您所点的饮料，请重新点(coca或coffee)。";
    public String getDescription(){
        return description;
    }
    public double getCost(){
        return 0;
    }
}
