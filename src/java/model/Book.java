package model;

public class Book {
    private int CarID;
    private String Carname;
    private String StartDate;
    private String ReturnDate;
    private int Amount;
    private String Statuss;
    

    public Book() {
    }

    public Book(int CarID, String Carname, String StartDate, String ReturnDate, int Amount, String Statuss) {
        this.CarID = CarID;
        this.Carname = Carname;
        this.StartDate = StartDate;
        this.ReturnDate = ReturnDate;
        this.Amount = Amount;
        this.Statuss = Statuss;
    }

    public int getCarID() {
        return CarID;
    }

    public void setCarID(int CarID) {
        this.CarID = CarID;
    }

    public String getCarname() {
        return Carname;
    }

    public void setCarname(String Carname) {
        this.Carname = Carname;
    }

    public String getStartDate() {
        return StartDate;
    }

    public void setStartDate(String StartDate) {
        this.StartDate = StartDate;
    }

    public String getReturnDate() {
        return ReturnDate;
    }

    public void setReturnDate(String ReturnDate) {
        this.ReturnDate = ReturnDate;
    }

    public int getAmount() {
        return Amount;
    }

    public void setAmount(int Amount) {
        this.Amount = Amount;
    }

    public String getStatuss() {
        return Statuss;
    }

    public void setStatuss(String Statuss) {
        this.Statuss = Statuss;
    }
    
    
}