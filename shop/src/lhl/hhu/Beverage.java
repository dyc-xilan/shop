package lhl.hhu;

public abstract class Beverage {
    String description = "Unknown Beverage";//用于描述当前饮料

    public String getDescription() {
        return description;
    }//用于计算当前饮料费用

    public abstract double getCost();
}
