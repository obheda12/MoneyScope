#!/bin/bash

bgreen='\033[1;32m'
green='\033[0;32m'
reset='\033[0m'

printf "\n${bgreen}"
printf '  /$$      /$$                                                /$$$$$$ \n'
printf ' | $$$    /$$$                                               /$$__  $$ \n'
printf ' | $$$$  /$$$$  /$$$$$$  /$$$$$$$   /$$$$$$  /$$   /$$      | $$  \__/  /$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$ \n'
printf ' | $$ $$/$$ $$ /$$__  $$| $$__  $$ /$$__  $$| $$  | $$      |  $$$$$$  /$$_____/ /$$__  $$ /$$__  $$ /$$__  $$ \n'
printf ' | $$  $$$| $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$  | $$       \____  $$| $$      | $$  \ $$| $$  \ $$| $$$$$$$$ \n'
printf ' | $$\  $ | $$| $$  | $$| $$  | $$| $$_____/| $$  | $$       /$$  \ $$| $$      | $$  | $$| $$  | $$| $$_____/ \n'
printf ' | $$ \/  | $$|  $$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$$      |  $$$$$$/|  $$$$$$$|  $$$$$$/| $$$$$$$/|  $$$$$$$ \n'
printf ' |__/     |__/ \______/ |__/  |__/ \_______/ \____  $$       \______/  \_______/ \______/ | $$____/  \_______/ \n'
printf '                                             /$$  | $$                                    | $$ \n'
printf '                                            |  $$$$$$/                                    | $$ \n'
printf '                                             \______/                                     |__/ \n'
echo " "
printf "${reset}"

a_flag='false'
c_flag='false'
i_flag='false'
h_flag='false'
b_flag='false'
y_flag='false'
o_flag='false'

print_usage() {
  printf "\n${bgreen}"
  printf '$$$$$$$$$$$$$$$$$$$$$$$$$$$ Money Scope Usage Guide $$$$$$$$$$$$$$$$$$$$$$$$$$'
  printf "${reset}"
  printf "\n[-a] all [-i] intigriti [-h] hackerone [-b] bugcrowd [-y] yeswehack [-o] other\n"
}

print_usage
echo ""

clean_data() {
  cat tmp.txt | tr ',' '\n' > new.txt
  sort -u new.txt -o tmp.txt
  rm -rf new.txt

  sed -i '
  s/\*\.//g ;
  s/^\.// ;
  s/http[s]*:\/\/// ;
  s/\/.*$// ;
  / /d
  ' tmp.txt
  sed -i 's/www.//g' tmp.txt
  sed -i 's/<BR>/\n/g' tmp.txt
}

while getopts 'aihbyo' flag; do
  case "${flag}" in
    a) a_flag='true' ;;
    i) i_flag='true' ;;
    h) h_flag="true" ;;
    b) b_flag='true' ;;
    y) y_flag='true' ;;
    o) o_flag='true' ;;
    h) print_usage
       exit 1 ;;
  esac
done

if (($# == 0))
then
    echo "No arguments specified. Please refer to the help guide above and specify an argument"
    echo "EXAMPLE: ./MoneyScope.sh -a (pulls all paid scopes from all sources)"
fi

if ${a_flag}; then
	echo "Gathering Paid Scopes From All Sources..."
	curl -sL https://github.com/projectdiscovery/public-bugbounty-programs/raw/master/chaos-bugbounty-list.json | jq -r '.programs[] | select(.bounty == true) | .domains' | sort -u | cut -d '"' -f2 >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/intigriti_data.json | jq -r '.[].targets.in_scope[] | select(.max_bounty!=0.0) | select(.type=="url") |  [.endpoint] |@tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/blob/master/data/hackerone_data.json?raw=true | jq -r '.[].targets.in_scope[] | select(.asset_type=="URL") | [.asset_identifier] | @tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/bugcrowd_data.json | jq -r '.[].targets.in_scope[] | select(.max_payout!=0) | select(.type=="website testing") | [.target] | @tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/yeswehack_data.json | jq -r '.[].targets.in_scope[] | select(.type=="web-application")| [.target]| @tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/hackenproof_data.json | jq -r '.[].targets.in_scope[]| select(.type=="Web")| [.target] | @tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/federacy_data.json | jq -r '.[].targets.in_scope[] | select(.type=="website") | [.target] | @tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > all_bbscope.txt
	sed -i '1d' all_bbscope.txt
	cat all_bbscope.txt | haktldextract | sort -u > all_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat all_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat all_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from All Sources Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""
fi

if ${i_flag}; then
	echo "Gathering Paid Scopes From Intigriti..."
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/intigriti_data.json | jq -r '.[].targets.in_scope[] | select(.max_bounty!=0.0) | select(.type=="url") |  [.endpoint] |@tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > intigriti_bbscope.txt
	sed -i '1d' intigriti_bbscope.txt
	cat intigriti_bbscope.txt | haktldextract | sort -u > intigriti_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat intigriti_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat intigriti_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from Intigriti Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""
fi

if ${h_flag}; then
	echo "Gathering Paid Scopes From HackerOne..."
	curl -sL https://github.com/arkadiyt/bounty-targets-data/blob/master/data/hackerone_data.json?raw=true | jq -r '.[].targets.in_scope[] | select(.asset_type=="URL") | [.asset_identifier] | @tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > h1_bbscope.txt
	sed -i '1d' h1_bbscope.txt
	cat h1_bbscope.txt | haktldextract | sort -u > h1_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat h1_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat h1_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from HackerOne Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""
fi

if ${b_flag}; then
	echo "Gathering Paid Scopes From Bugcrowd..."
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/bugcrowd_data.json | jq -r '.[].targets.in_scope[] | select(.max_payout!=0) | select(.type=="website") | [.target] | @tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > bugcrowd_bbscope.txt
	sed -i '1d' bugcrowd_bbscope.txt
	cat bugcrowd_bbscope.txt | haktldextract | sort -u > bugcrowd_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat bugcrowd_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat bugcrowd_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from Bugcrowd Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""
fi

if ${y_flag}; then
	echo "Gathering Paid Scopes From YesWeHack..."
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/yeswehack_data.json | jq -r '.[].targets.in_scope[] | select(.type=="web-application")| [.target]| @tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > yeswehack_bbscope.txt
	sed -i '1d' yeswehack_bbscope.txt
	cat yeswehack_bbscope.txt | haktldextract | sort -u > yeswehack_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat yeswehack_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat yeswehack_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from YesWeHack Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""

fi

if ${o_flag}; then
	echo "Gathering Paid Scopes From Other (Hackenproof and Federacy Data)..."
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/hackenproof_data.json | jq -r '.[].targets.in_scope[]| select(.type=="Web")| [.target] | @tsv' >> tmp.txt
	curl -sL https://github.com/arkadiyt/bounty-targets-data/raw/master/data/federacy_data.json | jq -r '.[].targets.in_scope[] | select(.type=="website") | [.target] | @tsv' >> tmp.txt
	clean_data

	cat tmp.txt | tr -d '(' | tr -d ')' | tr -d '*' | sed '/\[/d ; s/^\.//' | sort -u > other_bbscope.txt
	sed -i '1d' other_bbscope.txt
	cat other_bbscope.txt | haktldextract | sort -u > other_bbscope_tld.txt
	rm -rf scope.temp tmp.txt

	PAID_SCOPE_DOMAINS_COUNT=$(cat other_bbscope.txt | wc -l)
	PAID_SCOPE_TLDS_COUNT=$(cat other_bbscope_tld.txt | wc -l)

	printf "${green}All Paid Scopes from other Sources (Hackenproof and Federacy Data) Gathered! MoneyScope identified $PAID_SCOPE_DOMAINS_COUNT Domains and $PAID_SCOPE_TLDS_COUNT TLDs in scope with bounties. Enjoy :) ${reset}\n"
	echo ""
fi
