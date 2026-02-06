public without sharing class AgentStorefrontActions {
  @InvocableMethod(
    label='Get Storefronts By Name'
    description='Query Storefront__c by Name (contains) and return results as Apex-defined DTOs for reliable serialization.'
  )
  public static List<StorefrontResponse> invoke(
    List<StorefrontRequest> requests
  ) {
    StorefrontResponse out = new StorefrontResponse();
    out.storefronts = new List<StorefrontSummary>();
    out.success = false;
    out.message = null;

    StorefrontRequest req = (requests != null && !requests.isEmpty())
      ? requests[0]
      : null;
    String nameQuery = (req == null) ? null : req.storefrontName;

    try {
      if (String.isBlank(nameQuery)) {
        out.message = 'storefrontName is required.';
        return new List<StorefrontResponse>{ out };
      }

      List<Storefront__c> storefronts = [
        SELECT
          Name,
          Description__c,
          Cuisine__c,
          Average_Review_Score__c,
          Image_URL__c,
          Phone__c,
          Address__c,
          Type__c
        FROM Storefront__c
        WHERE Name LIKE :('%' + nameQuery + '%')
        ORDER BY Name ASC
        LIMIT 200
      ];

      for (Storefront__c sf : storefronts) {
        StorefrontSummary s = new StorefrontSummary();
        s.name = sf.Name;
        s.description = sf.Description__c;
        s.cuisine = sf.Cuisine__c;
        s.averageReviewScore = sf.Average_Review_Score__c;
        s.imageUrl = sf.Image_URL__c;
        s.phone = sf.Phone__c;
        s.storefrontType = sf.Type__c;

        // Address__c is a compound field - format it as a single string
        if (sf.Address__c != null) {
          List<String> addressParts = new List<String>();
          if (String.isNotBlank(sf.Address__c.getStreet()))
            addressParts.add(sf.Address__c.getStreet());
          if (String.isNotBlank(sf.Address__c.getCity()))
            addressParts.add(sf.Address__c.getCity());
          if (String.isNotBlank(sf.Address__c.getState()))
            addressParts.add(sf.Address__c.getState());
          if (String.isNotBlank(sf.Address__c.getPostalCode()))
            addressParts.add(sf.Address__c.getPostalCode());
          s.address = String.join(addressParts, ', ');
        }

        out.storefronts.add(s);
      }

      out.success = true;
    } catch (Exception e) {
      out.success = false;
      out.message = e.getMessage();
    }

    return new List<StorefrontResponse>{ out };
  }

  public class StorefrontRequest {
    @InvocableVariable(
      label='Storefront Name'
      description='Full or partial storefront name to search for. Matches Storefront__c.Name using a contains search.'
      required=true
    )
    public String storefrontName;
  }

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
      description='A list of storefront summaries matching the provided storefrontName.'
    )
    public List<StorefrontSummary> storefronts;
  }
}
