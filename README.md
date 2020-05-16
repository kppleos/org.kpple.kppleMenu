# Kpple Menu

<p align="center">
    <img src="screenshots/kppleMenu.png" alt="kpple menu preview">
</p>

## How to install the kpple menu without kpple OS on KDE Plasma ?

The recommended installation method is via the KDE store.

### You can also use another install method ( by git ) :

Open a terminal and follow the steps below.

```bash

git clone https://github.com/kppleos/org.kpple.kppleMenu
mv org.kpple.kppleMenu/package/* org.kpple.kppleMenu/
rm org.kpple.kppleMenu/package/
mv org.kpple.kppleMenu/ ~/.local/share/plasma/plasmoids/org.kpple.kppleMenu 

```

