# Digitalocean Marketplace Image

This README provides instructions for creating an Osmosis golden image using Packer for distribution on the DigitalOcean Marketplace.

## Prerequisites

### DigitalOcean Account

Before proceeding, make sure you have a DigitalOcean account and create a personal access token. Follow these steps:

1. Log in to your DigitalOcean account and go to the "Manage" section in the left-most navigation menu.
2. Select "API" and then click on "Generate New Token".
3. Provide a token name, expiration, and give read and write scopes.
4. Click on "Generate Token" to create the token.
5. Once generated, make sure to copy and securely store the token. It will not be shown again.
6. Export the token as an environment variable by running the following command in your terminal, replacing `your_token` with the actual token:

```bash
export DIGITALOCEAN_TOKEN=your_token
```

### Packer

If you do not already have packer installed you can install it with `brew`:

```bash
brew install packer
```

or with `apt` on Ubuntu:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install packer
```

## Updating the Image

To update the image, you'll typically need to change the `application_version` variable in the `marketplace-image.json` file. Follow these steps:

1. Open the `marketplace-image.json` file.
2. Locate the `variables` section and find the `application_version` variable.
3. Update the value to the desired version (e.g., "v7.2.0").
4. If any external dependencies change in the future (e.g., upgrading from Go 1.17 to 1.18), modify the relevant code in the `01-osmosis.sh` file located in the `scripts/` folder.

After making these changes and ensuring that the `DIGITALOCEAN_TOKEN` environment variable is set, you can build the image using the following command:

```bash
packer build marketplace-image.json
```

The above command will spin up a node, install dependencies, clean and prepare for a snapshot, power down the VM, take a snapshot, and then remove the VM.

Once the process is complete (usually within 10-15 minutes), you will see a success message in your terminal. Additionally, you can find the final image under the "Images" section in the "Manage" menu on the DigitalOcean website.

You can now use this image to submit to the Marketplace through the vendor portal.