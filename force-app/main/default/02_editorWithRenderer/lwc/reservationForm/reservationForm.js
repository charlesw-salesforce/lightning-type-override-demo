import { LightningElement, api } from "lwc";

const SEATING_TYPES = ["Booth", "Bar", "Balcony"];

export default class ReservationDemoApp extends LightningElement {
  reservationDate;
  startTime = "18:00";
  guestName = "";
  phone = "";
  numberOfGuests = 2;
  specialRequests = "";
  seatingType = "Booth";

  toast = { visible: false, message: "" };

  @api
  get value() {
    return {
      reservationDate: this.reservationDate,
      startTime: this.startTime,
      guestName: this.guestName,
      phone: this.phone,
      numberOfGuests: this.numberOfGuests,
      specialRequests: this.specialRequests,
      seatingType: this.seatingType
    };
  }
  set value(val) {
    if (val) {
      this.reservationDate = val.reservationDate;
      this.startTime = val.startTime || "18:00";
      this.guestName = val.guestName || "";
      this.phone = val.phone || "";
      this.numberOfGuests = val.numberOfGuests != null ? val.numberOfGuests : 2;
      this.specialRequests = val.specialRequests || "";
      this.seatingType = val.seatingType || "Booth";
    }
  }

  connectedCallback() {
    const today = new Date();
    this.reservationDate = today.toISOString().slice(0, 10);
  }

  get timeOptions() {
    const options = [];
    for (let h = 8; h <= 22; h++) {
      for (let m = 0; m < 60; m += 30) {
        if (h === 22 && m > 0) break;
        const hh = String(h).padStart(2, "0");
        const mm = String(m).padStart(2, "0");
        const timeVal = `${hh}:${mm}`;
        const displayHour = h % 12 || 12;
        const period = h >= 12 ? "PM" : "AM";
        const label = `${displayHour}:${mm} ${period}`;
        options.push({ label, value: timeVal });
      }
    }
    return options;
  }

  get seatingOptions() {
    return SEATING_TYPES.map((type) => ({
      label: type,
      value: type,
      buttonClass:
        this.seatingType === type
          ? "seating-button selected"
          : "seating-button"
    }));
  }

  dispatchValueChange() {
    this.dispatchEvent(
      new CustomEvent("valuechange", {
        detail: {
          value: this.value
        },
        bubbles: true,
        composed: true
      })
    );
  }

  handleInputChange(event) {
    event.stopPropagation();

    const fieldName = event.target.name;
    const fieldValue = event.target.value;

    this[fieldName] = fieldValue;
    this.dispatchValueChange();
  }

  handleSeatingClick(event) {
    event.stopPropagation();
    this.seatingType = event.currentTarget.dataset.value;
    this.dispatchValueChange();
  }
}
