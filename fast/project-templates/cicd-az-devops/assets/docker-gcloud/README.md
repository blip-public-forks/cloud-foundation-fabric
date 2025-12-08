# Self-hosted Agents on GCE Using Instance Service Account

This example shows one way of bootstrapping self-hosted Azure Devops agents on Compute Engine, using Container Optimized OS instances scaled via a Managed Instance Group.

## Agent Azure Devops token

The Azure Devops token required by the agent is fetched at runtime from Secret Manager via systemd unit, and made available to the agent's container image via a local file. This removes the need of having the GCP SDK available from within the container image, and provides a similar level of security since the token would still be available to instance admins even when fetched from within the container itself.

An alternate container image is provided which deviates from the example provided in the Azure Devops documentation, and which  embeds the `gcloud` commands where a different approach is desirable.

## Agent GCP credentials

Agents leverage the credentials of the service account associated to the instances, removing the need to set up a Service Connection on the Devops side, and a corresponding Workload Identity configuration on the GCP side.

The drawback is of course that the set of instances shares a single identity, which makes this approach unsuitable where different permissions are required for different pipelines.

Working around this limitation requires some complexity:

- multiple agents can be configured on the instance in the systemd unit (or via multiple units), each using a different secret for its token
- each agent would leverage the instance's service account credentials to impersonate a separate service accounts, and derive a short-lived token used for GCP requests
- each agent's container image would periodically rotate the short-lived tokens so that they are always available to running jobs, or the agent would need to be configured as ["Run once"](https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/linux-agent?view=azure-devops&tabs=IP-V4#run-once) and its restart managed by systemd

A deployment on GKE is probably easier than implementing the above workarounds.
