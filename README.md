# Chia

A mix of tools and scripts for [chia](https://github.com/Chia-Network/chia-blockchain/).

## plotCreate.ps1

**Chia**

The documentation for the input parameters can be found on the [chia github wiki page](https://github.com/Chia-Network/chia-blockchain/wiki/CLI-Commands-Reference#create).

**Pushover**

You can notify yourself via Pushover when plotting has finished. If your not familiar with pushover here is a brief instruction:
 * Create your own account [here](https://www.pushover.net)
 * Install the app called Pushover on your mobile or buy the desktop app (5$ one time payment per platform)
 * Log into your account on the Pushover website and navigate to the [main page](https://www.pushover.net/)
   * `pushoverUserKey`: On the top right corner you will see your user key below the text *Your User Key* 
   * `pushoverApiTokenKey`: If you scroll down the website you can create a new applicatiopn by clicking *Create an Application/API Token*
     * Name: f.e. Chia
     * Icon: f.e. use the chia icon from their [github repository](https://github.com/Chia-Network)
     * After creating the application the *pushoverApiTokenKey* can be found on the top of the website below the text *API Token/Key*
 * Please be aware that Pushover applications are limited to 7500 messages per month each

## startFarmer.sh

Start chia farmer.

## stopFarmer.sh

Stop chia.

## updateBinaries.sh

1. Stop chia
2. Create backup
3. Update local git repository
4. Install chia
5. Init chia