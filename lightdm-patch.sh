# arrange lightdm
LIGHTDMFILE=/etc/lightdm/lightdm.conf
if [ -f $LIGHTDMFILE ]
then
	mv $LIGHTDMFILE $LIGHTDMFILE.bkp
fi
echo "[SeatDefaults]
allow-guest=false
greeter-show-manual-login=true
greeter-hide-users=true" > $LIGHTDMFILE

