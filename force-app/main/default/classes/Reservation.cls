// Data Transfer Objects for Reservation demo
public with sharing class Reservation {
  public class ReservationBlock {
    @AuraEnabled
    public Date reservationDate;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public Boolean isAvailable;
    @AuraEnabled
    public String resourceName;
    @AuraEnabled
    public String blockId;

    public ReservationBlock() {
    }

    public ReservationBlock(
      Date reservationDate,
      String startTime,
      Boolean isAvailable,
      String resourceName,
      String blockId
    ) {
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.isAvailable = isAvailable;
      this.resourceName = resourceName;
      this.blockId = blockId;
    }
  }

  public class ReservationRequest {
    @InvocableVariable(required=true)
    public Date reservationDate;
    @InvocableVariable(required=true)
    public String startTime;
    @InvocableVariable(required=true)
    public String phone;
    @InvocableVariable(required=true)
    public Integer numberOfGuests;
    @InvocableVariable
    public String specialRequests;

    public ReservationRequest() {
    }

    public ReservationRequest(
      Date reservationDate,
      String startTime,
      String phone,
      Integer numberOfGuests,
      String specialRequests
    ) {
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.phone = phone;
      this.numberOfGuests = numberOfGuests;
      this.specialRequests = specialRequests;
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
    public String phone;
    @InvocableVariable(required=true)
    public Integer numberOfGuests;
    @InvocableVariable
    public String specialRequests;
    @InvocableVariable(required=true)
    public String status;

    public ReservationConfirmation() {
    }

    public ReservationConfirmation(
      String confirmationCode,
      Date reservationDate,
      String startTime,
      String phone,
      Integer numberOfGuests,
      String specialRequests,
      String status
    ) {
      this.confirmationCode = confirmationCode;
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.phone = phone;
      this.numberOfGuests = numberOfGuests;
      this.specialRequests = specialRequests;
      this.status = status;
    }
  }
}
