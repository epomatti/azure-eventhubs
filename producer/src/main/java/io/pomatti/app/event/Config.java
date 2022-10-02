package io.pomatti.app.event;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class Config {

  @Value("${azure.eventhub.connectionString}")
  private String connectionString;

  @Value("${azure.eventhub.name}")
  private String eventHubName;

  public String getConnectionString() {
    return connectionString;
  }

  public void setConnectionString(String connectionString) {
    this.connectionString = connectionString;
  }

  public String getEventHubName() {
    return eventHubName;
  }

  public void setEventHubName(String eventHubName) {
    this.eventHubName = eventHubName;
  }

}
