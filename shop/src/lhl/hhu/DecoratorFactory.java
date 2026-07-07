package lhl.hhu;

public class DecoratorFactory implements Factory {
    private String decorator;
    private Beverage beverage;
    public Beverage getDecorator(String decorator, Beverage beverage){
        this.decorator = decorator;
        this.beverage = beverage;
        if(decorator.equals("milk"))
            beverage = new MilkDecorator(beverage);
        else if(decorator.equals("ice"))
            beverage = new IceDecorator(beverage);
        //处理非法配料
        else beverage = new NoDecorator();
        return beverage;
    }
}
