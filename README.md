# patch_log4j

This cookbook scans for Log4j Core JAR files and patches them against CVE-2021-44228 and CVE-2021-45046 by removing their `JndiLookup.class` files.

## Usage

* [Install and configure Chef Client](https://learn.chef.io/) on the machines you want to patch.
* [Install and configure Chef Workstation](https://learn.chef.io/) on your developer workstation. 

Add the cookbook to your Chef server

```
cd <your cookbooks directory>
git clone https://github.com/trickyearlobe/patch-log4j
knife cookbook upload patch-log4j
```

## Disclaimer

* This cookbook was written while I was drunk and is probably not safe to run in production
* Please be very careful and test it before you use it outside the lab

If you'd like to help making it safe to run please submit fixes and tests via the normal PR process