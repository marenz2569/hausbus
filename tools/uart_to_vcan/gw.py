#!/usr/bin/env python3

import serial
from subprocess import call
import can
import json
import socket
import sys

print('a gateway for avr with can to socketcan')

try:
	ser = serial.Serial('/dev/ttyUSB0', 115200, parity=serial.PARITY_ODD, timeout=None)
except FileNotFoundError:
	print("No device '/dev/ttyUSB0'")
	sys.exit()
except serial.serialutil.SerialException:
	print('SerialException')
	sys.exit()

bus = can.interface.Bus(channel='vcan0', bustype='socketcan_native')

while True:
	try:
		cmd = ser.readline().decode('utf-8').strip('\r\n')
		cmd = json.loads(cmd)

		msg = can.Message(arbitration_id=cmd['id'], data=cmd['data'], extended_id=False)
		bus.send(msg)
	except can.CanError:
		print('Can message not send')
	except KeyboardInterrupt:
		print('KeyboardInterrupt')
		break
	except ValueError:
		pass
	except serial.serialutil.SerialException:
		print('SerialException')
		break
