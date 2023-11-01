This script primary target is rasperrypi with archlinux-arm connected to a large oled tv.

Dependencies:
```bash
pacman -S xorg-server xorg-xinit xorg-apps xdotool graphicsmagick ffmpeg some-font
```

Optional utility used to autostart X server over ssh without mouse of keyboard https://github.com/joukewitteveen/xlogin

possible `.xinitrc`:
```bash
xset s off -dpms
while true; do
    cat pic.list | shuf | bash root_slides.sh 13
done
```

remake picture list:
```bash
find pictures -type f | egrep -i -e репин -e кандинский >pic.list && kill $(pgrep -f root_slides.sh)
```

manual invocation should look like this
```bash
find pictures -type f | egrep -i -e репин -e кандинский | shuf | DISPLAY=:0 bash root_slides.sh
```

how should it look like

![PXL_20231101_181601483_](https://github.com/yekm/root_slides/assets/205196/d9c33409-5c18-4fd2-ace1-ee2ca9363e8e)
