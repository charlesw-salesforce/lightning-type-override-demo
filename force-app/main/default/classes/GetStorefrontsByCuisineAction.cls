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

  @InvocableMethod(
    label='Get Storefronts By Cuisine'
    description='Query Storefront__c by Cuisine (contains) and return results as Apex-defined DTOs.'
  )
  public static List<Storefront.StorefrontResponse> invoke(List<RequestWrapper> requests) {
    Storefront.StorefrontResponse out = new Storefront.StorefrontResponse();
    out.storefronts = new List<Storefront.StorefrontSummary>();
    out.success = false;
    out.message = null;

    RequestWrapper req = (requests != null && !requests.isEmpty())
      ? requests[0]
      : null;
    String cuisineQuery = (req == null) ? null : req.cuisine;

    try {
      if (String.isBlank(cuisineQuery)) {
        out.message = 'cuisine is required.';
        return new List<Storefront.StorefrontResponse>{ out };
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
        Storefront.StorefrontSummary s = new Storefront.StorefrontSummary();
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

    return new List<Storefront.StorefrontResponse>{ out };
  }
}
