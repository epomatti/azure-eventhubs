# Azure Event Hubs

Event Hubs with capture that writes events to storage.

Create the `.auto.tfvars` file:

```sh
cp infra/templates/sample.tfvars infra/.auto.tfvars
```

Create the infrastructure:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply -auto-approve
```

Run this to quickly get access to the access key:

```sh
az eventhubs namespace authorization-rule keys list \
    --name RootManageSharedAccessKey \
    -g rg-eventprocessor \
    --namespace-name evhns-eventprocessor-2069 \
    --query primaryConnectionString -o tsv
```

Add variables to your session:

```sh
export AZURE_EVENTHUB_CONNECTION_STRING='Endpoint={endpoint};SharedAccessKeyName={sharedAccessKeyName};SharedAccessKey={sharedAccessKey};EntityPath={entityPath}'
export AZURE_EVENTHUB_NAME="evh-eventprocessor"
```

Start the application:

```sh
mvn spring-boot:run
```

Send events to Event Hubs:

```sh
curl -X POST -H "Content-Type: application/json" -d '{"id":"123"}' localhost:8080/api/events/
```

Data should be sent to the Storage in `Avro` format.
