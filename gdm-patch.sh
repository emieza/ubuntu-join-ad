# hide user list
# https://help.gnome.org/admin/system-admin-guide/stable/login-userlist-disable.html.en

echo "
user-db:user
system-db:gdm
file-db:/usr/share/gdm/greeter-dconf-defaults
" > /etc/dconf/profile/gdm

mkdir -p /etc/dconf/db/gdm.d

echo "
[org/gnome/login-screen]
# Do not show the user list
disable-user-list=true
" > /etc/dconf/db/gdm.d/00-login-screen

dconf update

echo "GDM revisat (amagar noms d'usuaris). Reinicia per veure les efectes."
