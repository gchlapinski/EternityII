import os
import csv
import pickle
import ssl
import paho.mqtt.publish as publish

channelID = "857664"
apiKey = ""
mqttHost = "mqtt.thingspeak.com"

mvNo = 5
movePath = "./mvs/move" + str(mvNo)
logFile = "./mvs/log/dayLog.csv"
pathList = "./mvs/log/touched.list"
finishHim = 0
pth = ""

for r, d, f in os.walk(movePath):
    for drctr in d:
        pth = os.path.join(r, drctr)
        if "finito" in pth:
            finishHim = 1
            break

if finishHim > 0:
    noActivePath = 0
    noFinPath = 0
    noUntouched = 0
    timeCalc = 0.0
    noCalc = 0
    avgStepNo = 0
    maxStep = 256
else:
    noActivePath = 0
    noFinPath = 0
    for r, d, f in os.walk(movePath):
        for file in f:
            if file[-4:] == '.fin':
                noFinPath += 1
            else:
                noActivePath += 1

    if os.path.exists(logFile):
        noUntouched = noActivePath
        timeCalc = 0.0
        noCalc = 0
        avgStepNo = 0
        maxStep = mvNo
    else:
        with open(logFile) as csvfile:
            readCSV = csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_NONE)
            next(readCSV, None)

            listFilesNew = []
            timeCalc = 0.0
            noCalc = 0
            avgStepNo = 0
            maxStep = 0

            for row in readCSV:
                listFilesNew.append(row[0])
                timeCalc += float(row[1])/3600
                noCalc += 1
                avgStepNo += int(row[3])

                if int(row[5]) > maxStep:
                    maxStep = int(row[5])

        if os.path.exists(pathList):
            with open(pathList, "rb") as f:
                listFiles = pickle.load(f)
        else:
            listFiles = []

        listFiles = listFiles + listFilesNew
        listFiles = list(set(listFiles))

        with open(pathList, "wb") as f:
            pickle.dump(listFiles, f, pickle.HIGHEST_PROTOCOL)

        noUntouched = noActivePath - len(set(listFiles))
        avgStepNo = int(avgStepNo / noCalc)

# thingspeak:
# Field1: number of active possibilities
# Field2: number of inactive/finished possibilities
# Field3: number of untouched possibilities
# Field4: time of calculation [h]
# Field5: number of calculations (calculations of any possibilities)
# Field6: average step number
# Field7: the longest solution
# Field8: if success
tTransport = "websockets"
tTLS = {'ca_certs': "/etc/ssl/certs/ca-certificates.crt", 'tls_version': ssl.PROTOCOL_TLSv1}
tPort = 443
topic = "channels/" + channelID + "/publish/" + apiKey
tPayload = "field1=" + str(noActivePath) + "&field2=" + str(noFinPath) + \
           "&field3=" + str(noUntouched) + "&field4=" + str(timeCalc) + \
           "&field5=" + str(noCalc) + "&field6=" + str(avgStepNo) + \
           "&field7=" + str(maxStep) + "&field8=" + str(finishHim)

try:
    publish.single(topic, payload=tPayload, hostname=mqttHost, port=tPort, tls=tTLS, transport=tTransport)
finally:
    print("Something has happened")
