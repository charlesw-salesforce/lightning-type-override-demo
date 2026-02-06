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
    @AuraEnabled
    public Date reservationDate;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public String resourceName;
    @AuraEnabled
    public String email;
    @AuraEnabled
    public String phone;

    public ReservationRequest() {
    }

    public ReservationRequest(
      Date reservationDate,
      String startTime,
      String resourceName,
      String email,
      String phone
    ) {
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.resourceName = resourceName;
      this.email = email;
      this.phone = phone;
    }
  }

  public class ReservationDTO {
    @AuraEnabled
    public String confirmationCode;
    @AuraEnabled
    public Date reservationDate;
    @AuraEnabled
    public String startTime;
    @AuraEnabled
    public String resourceName;
    @AuraEnabled
    public String email;
    @AuraEnabled
    public String phone;
    @AuraEnabled
    public String status;

    public ReservationDTO() {
    }

    public ReservationDTO(
      String confirmationCode,
      Date reservationDate,
      String startTime,
      String resourceName,
      String email,
      String phone,
      String status
    ) {
      this.confirmationCode = confirmationCode;
      this.reservationDate = reservationDate;
      this.startTime = startTime;
      this.resourceName = resourceName;
      this.email = email;
      this.phone = phone;
      this.status = status;
    }
  }
}
