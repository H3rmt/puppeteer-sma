inotifywait -m -e modify images/screenshot.png |
   while read; do
       scp images/screenshot.png kiosk@10.0.0.2:/home/kiosk/screenshot.png
   done