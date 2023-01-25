import AlgoliaFoundation
import Foundation

public class InsightsClient: Client {
  /**
   - Parameter appID: Algolia application ID.
   - Parameter apiKey: Algolia API key of the application.
   */
  public convenience init(appID: ApplicationID,
                          apiKey: APIKey) {
    self.init(transport: Transport(hosts: []), jsonEncoder: JSONEncoder(), jsonDecoder: JSONDecoder())
  }
  
}
