// Shared data transfer objects for Storefront actions
public with sharing class Storefront {
  public class StorefrontSummary {
    @InvocableVariable(
      label='Name'
      description='The storefront name (Storefront__c.Name).'
    )
    public String name;

    @InvocableVariable(
      label='Description'
      description='Storefront description (Storefront__c.Description__c).'
    )
    public String description;

    @InvocableVariable(
      label='Cuisine'
      description='Cuisine type (Storefront__c.Cuisine__c).'
    )
    public String cuisine;

    @InvocableVariable(
      label='Average Review Score'
      description='Average review score (Storefront__c.Average_Review_Score__c).'
    )
    public Decimal averageReviewScore;

    @InvocableVariable(
      label='Image URL'
      description='Storefront image URL (Storefront__c.Image_URL__c).'
    )
    public String imageUrl;

    @InvocableVariable(
      label='Phone'
      description='Contact phone number (Storefront__c.Phone__c).'
    )
    public String phone;

    @InvocableVariable(
      label='Address'
      description='Physical address (Storefront__c.Address__c).'
    )
    public String address;

    @InvocableVariable(
      label='Type'
      description='Storefront type (Storefront__c.Type__c).'
    )
    public String storefrontType;
  }

  public class StorefrontResponse {
    @InvocableVariable(
      label='Success'
      description='True when the action executed successfully. False when inputs are missing/invalid or an unexpected error occurred.'
    )
    public Boolean success;

    @InvocableVariable(
      label='Message'
      description='User-readable status message. On errors, explains what was missing or what failed.'
    )
    public String message;

    @InvocableVariable(
      label='Storefronts'
      description='A list of storefront summaries matching the search criteria.'
    )
    public List<StorefrontSummary> storefronts;
  }
}
