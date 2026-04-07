// Data Transfer Objects for Reservation demo
public with sharing class Reservation {
  public class ReservationRequest {
    @InvocableVariable(required=true)
    public Date reservationDate;
    @InvocableVariable(required=true)
    public String startTime;
    @InvocableVariable(required=true)
    public String guestName;
    @InvocableVariable(required=true)
    public String phone;
    @InvocableVariable(required=true)
    public Integer numberOfGuests;
    @InvocableVariable
    public String specialRequests;
    @InvocableVariable
    public String seatingType;

    public ReservationRequest() {
    }

    public ReservationRequest(
      Date reservationDate,
      String startTime,
      String guestName,
      String phone,
      Integer numberOfGuests,
      String specialRequests,
      String seatingType
    ) {
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.guestName = guestName;
      this.phone = phone;
      this.numberOfGuests = numberOfGuests;
      this.specialRequests = specialRequests;
      this.seatingType = seatingType;
    }
  }

  public class ReservationConfirmation {
    @InvocableVariable(required=true)
    public String confirmationCode;
    @InvocableVariable(required=true)
    public Date reservationDate;
    @InvocableVariable(required=true)
    public String startTime;
    @InvocableVariable(required=true)
    public String guestName;
    @InvocableVariable(required=true)
    public String phone;
    @InvocableVariable(required=true)
    public Integer numberOfGuests;
    @InvocableVariable
    public String specialRequests;
    @InvocableVariable(required=true)
    public String status;
    @InvocableVariable
    public String seatingType;

    public ReservationConfirmation() {
    }

    public ReservationConfirmation(
      String confirmationCode,
      Date reservationDate,
      String startTime,
      String guestName,
      String phone,
      Integer numberOfGuests,
      String specialRequests,
      String status,
      String seatingType
    ) {
      this.confirmationCode = confirmationCode;
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.guestName = guestName;
      this.phone = phone;
      this.numberOfGuests = numberOfGuests;
      this.specialRequests = specialRequests;
      this.status = status;
      this.seatingType = seatingType;
    }
  }
}
