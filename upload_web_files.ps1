# index.html
$html = ""
[IO.File]::WriteAllBytes("C:\inetpub\wwwroot\index.html", [Convert]::FromBase64String($html))

# styles.css
$css = ""
[IO.File]::WriteAllBytes("C:\inetpub\wwwroot\style.css", [Convert]::FromBase64String($css))

# script.js
$js = ""
[IO.File]::WriteAllBytes("C:\inetpub\wwwroot\script.js", [Convert]::FromBase64String($js))
