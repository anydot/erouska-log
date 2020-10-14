#!/usr/bin/python3
import exposure_pb2
from google.protobuf.json_format import MessageToJson
import sys

data = sys.stdin.buffer.read()

assert data[:16] == b"EK Export v1    "

print(MessageToJson(exposure_pb2.TemporaryExposureKeyExport.FromString(data[16:])))



