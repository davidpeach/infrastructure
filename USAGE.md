# Usage

## Install Terraform cli

Following installation guide for your operating system:

 - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Check it's working with `terraform -help`.

## Update values in tfvars file.

Update the values for your own setup.

## Login to terraform cloud

Firstly generate an access token in the terraform cloud dashboard.

Go to user settings > tokens.

Click "Create an API token", and give it a descriptive title and click create.

Copy the generated access token to your clipboard.

Log in to terraform with the cli with the following:

Run `terraform login` and follow the instructions. This will include pasting in your access token. Do that.

You should get a success and welcome message.

## Initialize terraform.

Initialize terraform to get all deps needed for the infrastructure to be built, by running `terraform init`.

## Setting up secret environment variables.

Run `terraform plan` in the root of the directory.

After a few moments it should give an error say some of the required variables are missing. We will generate and set them next.

There are a few different ways that you can pass vaiables to terraform cli. The way I prefer is to set `ENV` variables in my `.bashrc` / `.zshrc` file.

The format for setting them is as follows: if we have a required variable called `do_token`, we could pass it using an `ENV` by setting one called `TF_VAR_do_token`.

The same goes for the `github_token` one. We would set an `ENV` in our `.bashrc` file called `TF_VAR_github_token`.

### Digital Ocean Access Tokens

In your DO dashboard, go to API and click "Generate New Token". Give it a name, choose an expiration date (or no expiry) and click "Create Token".

Copy the generated access token and create an `ENV` variable in your `.bashrc` file as follows:
```
export TF_VAR_do_token=your_long_access_token_here
```

### Github Access Token

In your github account, go to settings > developer settings > Personal Access Tokens. I use the classic token for now.

Click "Generate new token" > classic token. 

Give it a descriptive note and select an appropriate token expiration.

Select the following scopes:

 - admin:org
 - repo
 - workflow

Click "Generate token".

Copy and paste that token into your `.bashrc` file like with the previous one:

```
export TF_VAR_github_token=your_github_access_token
```

### Laravel Encryption Secret

In order to handle laravel app env variables, I am taking advantage of Laravel's relatively new env encryption functionality.

This is opposed to defining a secret for each individual env variable.

As I am encrypting the env locally with a specific key, I will need that same key to be available inside the CI/CD workflow in the github action.

One last time, inside your `.bashrc` file, add an `ENV` variable for your encryption secret (32 characters long).

To make it easier for your testing, you can just copy the full example line below. This is what I've been using locally so please change it when going live.

```
export TF_VAR_laravel_encryption_secret=3UVsEgGVK36XN82KKeyLFMhvosbZN1aF
```

Source the `.bashrc` file with `source ~/.bashrc` or open a fresh terminal.

## Terraform Plan

From the root of the project run `terraform plan`. This wont do anything yet, but it will show you what changes it will make upon your instruction.

You should read through the comments in the `main.tf` file in order to understand what each section is doing.

## Setting up your initial infrastructure.

I say "initial" infrastructure, as there are a couple of manual steps that are needed to be done from within your digital ocean dashboard.

Run `terraform apply`. After it does a few moments of thinking, the cli should ask you to input a value to approve the building of your infrastructure. You need to type "yes" and press enter.

Your terraform will now be provisioning your infrastructure for you.

This will take some time as it builds your stuff, with the kubernetes cluster, and managed database the items that normally take a bit of time to complete.

The cli will give you updates for all of your items being made every 10 seconds. And will show you a success message when finished successfully.

## Manual infrastructure steps

We now need to complete a small number of manual steps (until I work out how to automate these also)

### Allow Kubernetes to pull from container registry

Despite both the container registry and the Kubernetes cluster being with Digital Ocean, by default the cluster wont have permissions to be able to pull an image from there.

But we need to give it that permission for when we deploy our app / website during the CI/CD phase.

Head to your container registry area in the Digital Ocean Dashboard and click the "Settings" tab. In here click edit for the "DigitalOcean Kubernetes integration" option.

Select your cluster and click save.

### Installing Kubernetes Marketplace plugins.

We will need two of the Kubernetes plugins for the Laravel deployment to deploy correctly.

Go to your Kubernetes area in your Digital Ocean dashboard and click into your cluster.

On the next page click the "Marketplace" tab.

At the time of writing, the two to install are actually the first two in the "Recommended for you" section. But if this is different for you, you can use the search field to find them.

The two plugins we need are:

 - NGINX Ingress Controller
 - Cert-Manager

 In the next guide I will be explaining how to use these plugins from within your kubernetes deploy config file. For now, all you need to do is click "Install" for both of them.

The NGINX Ingress Controller will create a Digital Ocean load balancer on your behalf. You then just need to point your domain name to the Load Balancer's I.P.address.

### Point your domain name to the load

In your Digital Ocean dashboard, go to the Networking page and click the "Load Balancers" tab.

You should see the Load Balancer that the NGINX Ingress Controller set up on your behalf.

In your DNS settings, point the domain name you'll be using for your app to the I.P. address of this Load Balancer.
