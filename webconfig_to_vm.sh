#!/bin/bash

#----Config---
VM_NAME="winvm"
RG_NAME="kml_rg_main-03cd5bc36be84b07"

for file in index.html styles.css script.js; do 
  if [ ! -f "$file" ]; then
    echo "missing file: $file"
    exit 1
  fi
done


#-----Encode to base64---
INDEX_B64=$(base64 -w 0 index.html)
STYLE_B64=$(base64 -w 0 styles.css)
SCRIPT_B64=$(base64 -w 0 script.js)

#----Powershell for the web file upload----
cat > upload_web_files.ps1 <<EOF
# index.html
\$html = "$INDEX_B64"
[IO.File]::WriteAllBytes("C:\\inetpub\\wwwroot\\index.html", [Convert]::FromBase64String(\$html))

# styles.css
\$css = "$STYLE_B64"
[IO.File]::WriteAllBytes("C:\\inetpub\\wwwroot\\style.css", [Convert]::FromBase64String(\$css))

# script.js
\$js = "$SCRIPT_B64"
[IO.File]::WriteAllBytes("C:\\inetpub\\wwwroot\\script.js", [Convert]::FromBase64String(\$js))
EOF


#---upload files to VM---
az vm run-command invoke \
  --resource-group "$RG_NAME" \
  --name "$VM_NAME" \
  --command-id "RunPowerShellScript" \
  --scripts "@upload_web_files.ps1"

