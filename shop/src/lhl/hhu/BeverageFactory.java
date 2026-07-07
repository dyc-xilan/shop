package lhl.hhu;

public class BeverageFactory implements Factory{
    private String beverageName;
    private Beverage beverage;
    public Beverage getBeverage(String beverageName){
        this.beverageName = beverageName;
        if(beverageName.equals("coca"))
            beverage = new Coca();
        else if(beverageName.equals("coffee"))
            beverage = new Coffee();
        //处理非法饮料
        else beverage = new NoBeverage();
        return beverage;
    }
}


