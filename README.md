# Azure Event Hub

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Add variables to your session:

```sh
export AZURE_EVENTHUB_CONNECTION_STRING="Endpoint={endpoint};SharedAccessKeyName={sharedAccessKeyName};SharedAccessKey={sharedAccessKey};EntityPath={entityPath}"
export AZURE_EVENTHUB_NAME="evh-eventprocessor"
```

Start the application:

```sh
mvn spring-boot:run
```

Send a POST to http://localhost:8080/api/events/

Data should be sent to the Storage in `Avro` format.
