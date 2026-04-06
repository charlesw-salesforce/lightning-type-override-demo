import { LightningElement, api } from "lwc";

export default class StorefrontDisplay extends LightningElement {
  @api value;

  storefronts = [];
  currentIndex = 0;

  connectedCallback() {
    if (Array.isArray(this.value)) {
      this.storefronts = this.value;
    } else if (this.value) {
      this.storefronts = [this.value];
    }
  }

  get hasStorefronts() {
    return this.storefronts && this.storefronts.length > 0;
  }

  get hasMultiple() {
    return this.storefronts && this.storefronts.length > 1;
  }

  get currentStorefront() {
    return this.storefronts[this.currentIndex] || {};
  }

  get fullImageUrl() {
    const imageUrl = this.currentStorefront.imageUrl;
    if (!imageUrl) return null;
    if (imageUrl.startsWith("http")) return imageUrl;
    return `${imageUrl}`;
  }

  get positionIndicator() {
    if (!this.hasStorefronts) return "";
    return `${this.currentIndex + 1} of ${this.storefronts.length}`;
  }

  get formattedScore() {
    const score = this.currentStorefront.averageReviewScore;
    if (!score && score !== 0) return "N/A";
    return score.toFixed(1);
  }

  get stars() {
    const score = this.currentStorefront.averageReviewScore || 0;
    const roundedScore = Math.round(score);
    const stars = [];

    for (let i = 1; i <= 5; i++) {
      const isFilled = i <= roundedScore;
      stars.push({
        index: i,
        variant: isFilled ? "inverse" : undefined
      });
    }

    return stars;
  }

  handlePrevious() {
    if (this.hasStorefronts) {
      this.currentIndex =
        (this.currentIndex - 1 + this.storefronts.length) %
        this.storefronts.length;
    }
  }

  handleNext() {
    if (this.hasStorefronts) {
      this.currentIndex = (this.currentIndex + 1) % this.storefronts.length;
    }
  }
}
