# iOS App - License Plates Detector
<p align="justify">
This app is useful to detect license plates. The app use <em><strong>YoloV3</strong></em> and <em><strong>OpenCV</strong></em>. You can open the app and choose the image from library or take a photo. Next you can click the button to begin a detection of license plates. After that the app connect with the API and make the detection. In the end the app show you an image with marked detected  license plates and save numbers in history. You can always delete specific or all license plates from the history on the second screen.
</p><br/>

# Steps to run the app:<br/>
  1. Go to the ***API*** folder and run an ***api.py***<br/>
  2. If IP generated in console is different then the IP in ***App/Api.swift*** in ***\_apiAddress\_***  change it<br/>
  3. Run the iOS app on simulator or physical device<br/>
  4. Choose the image from image library or take a photo<br/>
  5. Click the button ***'Detect license plate'***<br/>
  6. Wait about 1 minute for detection<br/>
  7. You can see your license plates history on the second screen called ***'History'***<br/>
  8. You can delete specific or all license plates from history<br/>
  9. Back to step 4<br/>
