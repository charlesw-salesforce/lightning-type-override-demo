// Invocable action to retrieve storefronts by cuisine type
public with sharing class GetStorefrontsByCuisineAction {
  public class RequestWrapper {
    @InvocableVariable(
      label='Cuisine'
      description='The cuisine type to search for (e.g. Italian, Mexican, Thai). Matches Storefront__c.Cuisine__c using a contains search.'
      required=true
    )
    public String cuisine;
  }

  public class StorefrontSummary {
    @InvocableVariable(label='Name' description='The storefront name.')
    public String name;

    @InvocableVariable(label='Description' description='Storefront description.')
    public String description;

    @InvocableVariable(label='Cuisine' description='Cuisine type.')
    public String cuisine;

    @InvocableVariable(
      label='Average Review Score'
      description='Average review score.'
    )
    public Decimal averageReviewScore;

    @InvocableVariable(label='Image URL' description='Storefront image URL.')
    public String imageUrl;

    @InvocableVariable(label='Phone' description='Contact phone number.')
    public String phone;

    @InvocableVariable(label='Address' description='Physical address.')
    public String address;

    @InvocableVariable(label='Type' description='Storefront type.')
    public String storefrontType;
  }

  public class ResponseWrapper {
    @InvocableVariable(label='Success' description='True when the action executed successfully.')
    public Boolean success;

    @InvocableVariable(label='Message' description='User-readable status message.')
    public String message;

    @InvocableVariable(label='Storefronts' description='A list of storefront summaries matching the provided cuisine.')
    public List<StorefrontSummary> storefronts;
  }

  @InvocableMethod(
    label='Get Storefronts By Cuisine'
    description='Query Storefront__c by Cuisine (contains) and return results as Apex-defined DTOs.'
  )
  public static List<ResponseWrapper> invoke(List<RequestWrapper> requests) {
    ResponseWrapper out = new ResponseWrapper();
    out.storefronts = new List<StorefrontSummary>();
    out.success = false;
    out.message = null;

    RequestWrapper req = (requests != null && !requests.isEmpty())
      ? requests[0]
      : null;
    String cuisineQuery = (req == null) ? null : req.cuisine;

    try {
      if (String.isBlank(cuisineQuery)) {
        out.message = 'cuisine is required.';
        return new List<ResponseWrapper>{ out };
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
        WHERE Cuisine__c LIKE :('%' + cuisineQuery + '%')
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

    return new List<ResponseWrapper>{ out };
  }
}
