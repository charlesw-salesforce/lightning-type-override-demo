public with sharing class ReservationScheduleService {
  private static final Integer BLOCK_MINUTES = 30;
  private static final String OPENING_TIME = '08:00';
  private static final String CLOSING_TIME = '22:00';
  private static final List<String> RESOURCES = new List<String>{
    'Dining Room',
    'Bar',
    'Patio'
  };

  @AuraEnabled(cacheable=true)
  public static List<Reservation.ReservationBlock> generateSchedule(
    Date reservationDate,
    String centerTime
  ) {
    List<Reservation.ReservationBlock> results = new List<Reservation.ReservationBlock>();
    if (reservationDate == null) {
      return results;
    }

    if (String.isBlank(centerTime)) {
      centerTime = '18:00';
    }

    List<String> timeSlots = generateTimeSlots(centerTime, 1, 1);

    for (String resourceName : RESOURCES) {
      for (String startTime : timeSlots) {
        String blockId =
          String.valueOf(reservationDate) +
          ':' +
          resourceName +
          ':' +
          startTime;
        Boolean isAvailable = isWithinOperatingHours(startTime);

        results.add(
          new Reservation.ReservationBlock(
            reservationDate,
            startTime,
            isAvailable,
            resourceName,
            blockId
          )
        );
      }
    }
    return results;
  }

  @TestVisible
  private static List<String> generateTimeSlots(
    String centerTime,
    Integer slotsBefore,
    Integer slotsAfter
  ) {
    List<String> slots = new List<String>();

    for (Integer i = slotsBefore; i > 0; i--) {
      slots.add(addMinutesToTimeString(centerTime, -i * BLOCK_MINUTES));
    }

    slots.add(centerTime);

    for (Integer i = 1; i <= slotsAfter; i++) {
      slots.add(addMinutesToTimeString(centerTime, i * BLOCK_MINUTES));
    }

    return slots;
  }

  @TestVisible
  private static Boolean isWithinOperatingHours(String timeString) {
    Integer timeInMinutes = convertTimeToMinutes(timeString);
    Integer openingMinutes = convertTimeToMinutes(OPENING_TIME);
    Integer closingMinutes = convertTimeToMinutes(CLOSING_TIME);
    return timeInMinutes >= openingMinutes && timeInMinutes < closingMinutes;
  }

  @TestVisible
  private static Integer convertTimeToMinutes(String timeString) {
    List<String> parts = timeString != null
      ? timeString.split(':')
      : new List<String>();
    if (parts.size() != 2) {
      return 0;
    }
    Integer h = Integer.valueOf(parts[0]);
    Integer m = Integer.valueOf(parts[1]);
    return h * 60 + m;
  }

  @TestVisible
  private static String addMinutesToTimeString(
    String hhmm,
    Integer minutesToAdd
  ) {
    List<String> parts = hhmm != null ? hhmm.split(':') : new List<String>();
    if (parts.size() != 2) {
      return hhmm;
    }
    Integer h = Integer.valueOf(parts[0]);
    Integer m = Integer.valueOf(parts[1]);
    Integer total = h * 60 + m + (minutesToAdd == null ? 0 : minutesToAdd);
    Integer newH = Math.mod(total, 24 * 60) / 60;
    Integer newM = Math.mod(total, 60);
    String hs = newH < 10 ? '0' + String.valueOf(newH) : String.valueOf(newH);
    String ms = newM < 10 ? '0' + String.valueOf(newM) : String.valueOf(newM);
    return hs + ':' + ms;
  }
}
