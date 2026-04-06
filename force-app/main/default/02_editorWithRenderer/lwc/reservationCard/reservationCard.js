import { LightningElement, api } from "lwc";

export default class ReservationCard extends LightningElement {
  @api value;

  reservation = {};

  connectedCallback() {
    if (this.value) {
      this.reservation = this.value;
    } else {
      console.error("reservationCard: No value provided");
    }
  }

  get hasReservation() {
    return this.reservation && Object.keys(this.reservation).length > 0;
  }

  get formattedDate() {
    if (!this.reservation?.reservationDate) return "";
    const date = new Date(this.reservation.reservationDate);
    return date.toLocaleDateString("en-US", {
      weekday: "long",
      year: "numeric",
      month: "long",
      day: "numeric"
    });
  }

  get formattedTime() {
    if (!this.reservation?.startTime) return "";
    const [hours, minutes] = this.reservation.startTime.split(":");
    const h = parseInt(hours, 10);
    const period = h >= 12 ? "PM" : "AM";
    const displayHour = h % 12 || 12;
    return `${displayHour}:${minutes} ${period}`;
  }

  get statusVariant() {
    if (this.reservation?.status === "CONFIRMED") return "success";
    if (this.reservation?.status === "PENDING") return "warning";
    return "default";
  }

  get statusIcon() {
    if (this.reservation?.status === "CONFIRMED") return "utility:success";
    if (this.reservation?.status === "PENDING") return "utility:warning";
    return "utility:info";
  }
}
