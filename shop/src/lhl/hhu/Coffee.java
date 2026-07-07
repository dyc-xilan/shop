package lhl.hhu;

public class Coffee extends Beverage { //Coffee本身的描述与价格
    public Coffee() {
        description = "Coffee Beverage";
    }

    public double getCost() {
        return 2;
    }
}
