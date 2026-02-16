// Invocable action to simulate booking a reservation
public with sharing class BookReservationAction {
  public class RequestWrapper {
    @InvocableVariable(required=true)
    public Reservation.ReservationRequest request;
  }

  public class ResponseWrapper {
    @InvocableVariable
    public Reservation.ReservationDTO result;

    public ResponseWrapper(Reservation.ReservationDTO result) {
      this.result = result;
    }
  }

  @InvocableMethod(
    label='Book Reservation'
    description='Books a reservation and returns a confirmation DTO.'
  )
  public static List<ResponseWrapper> book(List<RequestWrapper> inputs) {
    List<ResponseWrapper> outputs = new List<ResponseWrapper>();
    if (inputs == null || inputs.isEmpty()) {
      return outputs;
    }

    for (RequestWrapper wrapper : inputs) {
      if (wrapper == null || wrapper.request == null) {
        continue;
      }
      Reservation.ReservationRequest req = wrapper.request;
      String confirmation = generateConfirmationCode(
        req.reservationDate,
        req.startTime
      );

      Reservation.ReservationDTO dto = new Reservation.ReservationDTO(
        confirmation,
        req.reservationDate,
        req.startTime,
        req.resourceName,
        req.email,
        req.phone,
        'CONFIRMED'
      );
      outputs.add(new ResponseWrapper(dto));
    }
    return outputs;
  }

  private static String generateConfirmationCode(
    Date reservationDate,
    String startTime
  ) {
    Date d = (reservationDate != null) ? reservationDate : Date.today();
    Datetime dt = Datetime.newInstance(d, Time.newInstance(0, 0, 0, 0));
    String datePart = dt.formatGmt('yyyyMMdd');
    String timePart = (startTime != null ? startTime.replace(':', '') : '0000');
    String randRaw = String.valueOf(Math.abs(Crypto.getRandomInteger()));
    String randPart = (randRaw.length() >= 6)
      ? randRaw.left(6)
      : (String.valueOf('000000' + randRaw)).right(6);
    return 'RES-' + datePart + '-' + timePart + '-' + randPart;
  }
}
