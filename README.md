![Logo](https://github.com/obheda12/MoneyScope/blob/main/MoneyScopeResized.png)
# MoneyScope
MoneyScope is a simple tool that pulls program scope data from a variety of sources, filters for all bug bounty scopes with an actual payout, and then filters again to remove any fluff/formatting issues in order to provide you with a succint scope of paying bounty domains and TLDs

# Requirements
Please install the following tools and have them in your /usr/bin folder prior to running MoneyScope:

- https://github.com/hakluke/haktldextract
- https://github.com/stedolan/jq

If you do not have these tools installed, please run the install.sh script

# Data Resources
MoneyScope relies on the Chaos Project as well as the repository @Arkadiyt (https://github.com/arkadiyt/bounty-targets-data) which update their sources daily.

To date MoneyScope pulls data from:
- Chaos Database
- HackerOne
- Bugcrowd
- Intigriti
- YesWeHack
- Federacy Data
- Hackenproof Data

# Usage
The usage of MoneyScope is fairly simple. Specify a flag as specified in the usage guide and MoneyScope will pull data for relative to the flag you have specified within seconds.

# Examples
Pull Paid Bounty Data from All Sources 
``` ./MoneyScope.sh -a ```

Pull Paid Bounty Data from Bugcrowd and Hackerone Only 
``` ./MoneyScope.sh -bh ```

Pull Paid Bounty Data from YesWeHack, Hackerone, and Intigriti Only 
``` ./MoneyScope.sh -yhi ```

# Output
MoneyScope will output data from paying bounty programs into 2 text files in your current working directory. The first file will be all the domains from the scope you specified. The second file be all the TLDs extracted from the domains you gathered using the tool by @hakluke (https://github.com/hakluke/haktldextract).

![Output](https://github.com/obheda12/MoneyScope/blob/main/MoneyScopeTerminalOutput.png)

## If you like MoneyScope and want to see more cool tools!
<a href="https://www.buymeacoffee.com/obheda12" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

# Disclaimer
This project is made for educational and ethical testing purposes only. Usage of this tool for attacking targets without prior mutual consent is illegal. Developers assume no liability and are not responsible for any misuse or damage caused by this tool.
