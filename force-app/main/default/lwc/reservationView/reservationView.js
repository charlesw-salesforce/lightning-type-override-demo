import { LightningElement, api } from "lwc";
import generateSchedule from "@salesforce/apex/ReservationScheduleService.generateSchedule";

export default class ReservationDemoApp extends LightningElement {
  centerTime = "18:00";
  reservationDate;
  startTime;
  resourceName = "Dining Room";
  email = "";
  phone = "";

  loading = false;
  blocks = [];
  resources = ["Dining Room", "Bar", "Patio"];
  toast = { visible: false, message: "" };

  @api
  get value() {
    return {
      reservationDate: this.reservationDate,
      startTime: this.startTime,
      resourceName: this.resourceName,
      email: this.email,
      phone: this.phone
    };
  }
  set value(val) {
    if (val) {
      this.reservationDate = val.reservationDate;
      this.startTime = val.startTime;
      this.resourceName = val.resourceName || "Dining Room";
      this.email = val.email || "";
      this.phone = val.phone || "";
    }
  }

  connectedCallback() {
    const today = new Date();
    this.reservationDate = today.toISOString().slice(0, 10);
    this.startTime = this.centerTime;
    this.loadSchedule();
  }

  get resourceOptions() {
    return this.resources.map((r) => ({ label: r, value: r }));
  }

  get visibleBlocks() {
    return (this.blocks || [])
      .filter((b) => b.resourceName === this.resourceName)
      .map((block) => ({
        ...block,
        buttonClass: this.getButtonClass(block.startTime)
      }));
  }

  async loadSchedule() {
    try {
      this.loading = true;
      const result = await generateSchedule({
        reservationDate: this.reservationDate,
        centerTime: this.centerTime
      });
      this.blocks = Array.isArray(result)
        ? result.map((block) => ({
            ...block,
            displayTime: this.formatTime(block.startTime)
          }))
        : [];
    } catch (e) {
      console.error("reservationView: Failed to load schedule", e);
      this.toast = {
        visible: true,
        message: "Something went wrong."
      };
    } finally {
      this.loading = false;
    }
  }

  // Dispatch a valuechange event to LTO container
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

    // Update component state
    this[fieldName] = fieldValue;

    // Handle special cases
    if (fieldName === "reservationDate" || fieldName === "centerTime") {
      if (fieldName === "centerTime") {
        this.startTime = fieldValue;
      }
      this.loadSchedule();
    }

    // Notify parent via valuechange event
    this.dispatchValueChange();
  }

  handleBlockClick(event) {
    event.stopPropagation();

    const btn = event.currentTarget;
    this.startTime = btn.dataset.start;

    this.dispatchValueChange();
  }

  // Helpers
  formatTime(timeString) {
    if (!timeString) return "";
    const [hours, minutes] = timeString.split(":");
    const h = parseInt(hours, 10);
    const period = h >= 12 ? "PM" : "AM";
    const displayHour = h % 12 || 12;
    return `${displayHour}:${minutes} ${period}`;
  }

  getButtonClass(blockTime) {
    const baseClass = "time-button";
    return this.startTime === blockTime ? `${baseClass} selected` : baseClass;
  }
}
