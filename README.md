> This is not a support platform. If you have issues with anything other than the apps
> (e.g. cloud instance, your cloud init, firewalls), please open up a support ticket as usual.

# Hetzner Cloud Apps

Our apps provide you easy access to often used software such as Docker, Wordpress or Nextcloud with the same intuitive workflow as you already know it from the Hetzner Cloud Server deployment.

## Contributions

At the moment we do not support contributions via Pull Request or other requests via Issues.

We want to improve the existing apps by focusing on bug reports.

If you see anything that does not work, feel free to open up one and let us know. Although it is possible to write us about other topics via the issues, we will not prioritize anything other than bugs and might even close issues we cannot tackle in a foreseeable future.

## How it works

We use a combination of [Packer](https://www.packer.io/) and [cloud-init](https://cloud-init.io/) to build a static image with all the required software in our cloud, create a snapshot, store it and if this image later will be deployed to your cloud instance, we will generate the dynamic information like passwords on demand directly in your server.

This results in as much transparency to the actual content as possible and allows you to reproduce what ends up in the app you deploy to your server by looking at the files in this repository.

## Structure

The officially by Hetzner maintained apps live under `apps/hetzner` and might use some generic scripts from `apps/shared`.
Each app will live in its own folder and have a dedicated `.github/workflows` file for the CI.

### Readme

Each app will have both a `README.md` and a `README.de.md` file which will give you a short oversight about the implementation of the software in our apps.
This will include what we have installed in this image, where you can find passwords if we have generated any and what you might need to configure by yourself.

These files will also be used to provide the documentation on https://docs.hetzner.com.

### Metadata

This file will contain some metadata which we use while displaying the app to you via our Cloud Console or public API.

### Development

We use GitHub Actions and [pre-commit](https://pre-commit.com/) to enforce different rule sets.
GitHub Actions run automatically on each Pull Request.

In order to set up your local machine to validate your changes with `pre-commit`, [install it](https://pre-commit.com/#install)
and run `pre-commit install` to enable the hooks locally.
