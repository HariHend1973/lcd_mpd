#!/usr/bin/python
#--------------------------------------
#    ___  ___  _ ____
#   / _ \/ _ \(_) __/__  __ __
#  / , _/ ___/ /\ \/ _ \/ // /
# /_/|_/_/  /_/___/ .__/\_, /
#                /_/   /___/
#
#  lcd_i2c.py
#  LCD test script using I2C backpack.
#  Supports 16x2 and 20x4 screens.
#
# Author : Matt Hawkins
# Date   : 20/09/2015
#
# Edited by: Tisaros Obengkumana
# Date     : 18/02/2016
#
# Modified by Pulpstone OpenWrt/LEDE
# Date     : 21/12/2017
#
# http://www.raspberrypi-spy.co.uk/
#
# Copyright 2015 Matt Hawkins
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#--------------------------------------
import smbus
import time
import os, sys
import time

# Define some device parameters
I2C_ADDR  = 0x3F # I2C device address
LCD_WIDTH = 20   # Maximum characters per line

# Define some device constants
LCD_CHR = 1 # Mode - Sending data
LCD_CMD = 0 # Mode - Sending command
LCD_CHARS = [0x40,0x48,0x50,0x58,0x60,0x68,0x70,0x78]

LCD_LINE_1 = 0x80 # LCD RAM address for the 1st line
LCD_LINE_2 = 0xC0 # LCD RAM address for the 2nd line
#LCD_LINE_2 = 0x0C # LCD RAM address for the 2nd line
LCD_LINE_3 = 0x94 # LCD RAM address for the 3rd line
LCD_LINE_4 = 0xD4 # LCD RAM address for the 4th line

LCD_BACKLIGHT  = 0x08  # On
#LCD_BACKLIGHT = 0x00  # Off

ENABLE = 0b00000100 # Enable bit

# Timing constants
E_PULSE = 0.0005
E_DELAY = 0.0005

#Open I2C interface
bus = smbus.SMBus(0)  # Rev 1 Pi uses 0
#bus = smbus.SMBus(1) # Rev 2 Pi uses 1

def lcd_init():
  # Initialise display
  lcd_byte(0x33,LCD_CMD) # 110011 Initialise
  lcd_byte(0x32,LCD_CMD) # 110010 Initialise
  lcd_byte(0x06,LCD_CMD) # 000110 Cursor move direction
  lcd_byte(0x0C,LCD_CMD) # 001100 Display On,Cursor Off, Blink Off
  lcd_byte(0x28,LCD_CMD) # 101000 Data length, number of lines, font size
  lcd_byte(0x01,LCD_CMD) # 000001 Clear display
  time.sleep(E_DELAY)

def lcd_byte(bits, mode):
  # Send byte to data pins
  # bits = the data
  # mode = 1 for data
  #        0 for command

  bits_high = mode | (bits & 0xF0) | LCD_BACKLIGHT
  bits_low = mode | ((bits<<4) & 0xF0) | LCD_BACKLIGHT

  # High bits
  bus.write_byte(I2C_ADDR, bits_high)
  lcd_toggle_enable(bits_high)

  # Low bits
  bus.write_byte(I2C_ADDR, bits_low)
  lcd_toggle_enable(bits_low)

def lcd_toggle_enable(bits):
  # Toggle enable
  time.sleep(E_DELAY)
  bus.write_byte(I2C_ADDR, (bits | ENABLE))
  time.sleep(E_PULSE)
  bus.write_byte(I2C_ADDR,(bits & ~ENABLE))
  time.sleep(E_DELAY)

def lcd_string(message,line):
  # Send string to display

  message = message.ljust(LCD_WIDTH," ")

  lcd_byte(line, LCD_CMD)

  for i in range(LCD_WIDTH):
    lcd_byte(ord(message[i]),LCD_CHR)

def lcd_custom(charPos,charDef):
  lcd_byte(LCD_CHARS[charPos],LCD_CMD)
  for line in charDef:
    lcd_byte(line,LCD_CHR)

def ss_get(b3_list,wifi):
  # get modem signal
  lcd_custom(1,[0x15,0x1F,0x15,0x04,0x04,0x04,0x0E,0x1F]) # wifiy
  lcd_custom(3,[0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F]) # full block
  lcd_custom(4,[0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F]) # empty block
  #lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # reserved
  #lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # reserved
  if b3_list[0] == "signal0":
    lcd_string("4G " + chr(4) + chr(4) + chr(4) + chr(4) + chr(4) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)
  if b3_list[0] == "signal20":
    lcd_string("4G " + chr(3) + chr(4) + chr(4) + chr(4) + chr(4) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)
  if b3_list[0] == "signal40":
    lcd_string("4G " + chr(3) + chr(3) + chr(4) + chr(4) + chr(4) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)
  if b3_list[0] == "signal60":
    lcd_string("4G " + chr(3) + chr(3) + chr(3) + chr(4) + chr(4) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)
  if b3_list[0] == "signal80":
    lcd_string("4G " + chr(3) + chr(3) + chr(3) + chr(3) + chr(4) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)
  if b3_list[0] == "signal100":
    lcd_string("4G " + chr(3) + chr(3) + chr(3) + chr(3) + chr(3) + b3_list[1] + " " + chr(1) + wifi,LCD_LINE_3)

def vol_get():
  # get voulme value
  global vol
  g=os.popen("mpc status | grep volume | awk '{print $1, $2}'")
  vol = ""
  for k in g.readlines():
    vol += k
  vol=vol.strip()
  vol=vol.replace("volume", "vol", 1)
  return (vol)

def mpc_get():
  # get mpc current
  vol_get()
  f=os.popen("mpc current")
  global station
  station = ""
  for i in f.readlines():
    station += i
    #station=station[:-1]
    station=station.rstrip()
    str_pad = " " * 20
    str_head = str_pad + vol + " " + chr(2) + chr(2) + " "
    str_trail = " " + chr(2) + chr(2) + " " + vol
    station = str_head + station + str_trail
    return (station)

def ud_get(b2):
  # get tx/rx
  #lcd_custom(1,[0x15,0x1F,0x15,0x04,0x04,0x04,0x0E,0x1F]) # reserved
  #lcd_custom(3,[0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F]) # reserved
  #lcd_custom(4,[0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F]) # reserved
  lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # up
  lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # down
  if len(b2) == 20: b2=chr(5) + chr(7) + b2
  if len(b2) == 19: b2=chr(5) + chr(7) + b2
  if len(b2) == 18: b2=chr(5) + chr(7) + b2
  if len(b2) == 17: b2=chr(5) + chr(7) + b2
  if len(b2) == 16: b2= " " + chr(5) + chr(7) + b2
  if len(b2) == 15: b2= " " + chr(5) + chr(7) + b2
  if len(b2) == 14: b2= "  " + chr(5) + chr(7) + b2
  if len(b2) == 13: b2= "  " + chr(5) + chr(7) + b2
  if len(b2) == 12: b2= "   " + chr(5) + chr(7) + b2
  if len(b2) == 11: b2= "   " + chr(5) + chr(7) + b2
  lcd_string(b2,LCD_LINE_2)

def temp_time_get(b4):
  # get time and temperature
  lcd_string("  " + chr(0) + b4 + " " + chr(6) + time.strftime("%H:%M:%S"),LCD_LINE_4)

def mpd_head_get():
  # get header
  lcd_string("      " + chr(2) + " MPD " + chr(2) + "     ", LCD_LINE_1)

def disk_get(disk_list):
  lcd_custom(1,[0x07,0x0F,0x11,0x17,0x11,0x17,0x17,0x1F]) # flashdisk
  #lcd_custom(3,[0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F]) # reserved
  #lcd_custom(4,[0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F]) # reserved
  #lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # reserved
  #lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # reserved
  lcd_string(chr(1) + disk_list[0], LCD_LINE_2)
  lcd_string(chr(1) + disk_list[1], LCD_LINE_3)

def mem_get(disk_list):
  lcd_custom(1,[0x15,0x15,0x1F,0x1F,0x1F,0x1F,0x15,0x15]) # memory
  #lcd_custom(3,[0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F]) # reserved
  #lcd_custom(4,[0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F]) # reserved
 #lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # reserved
  #lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # reserved
  lcd_string(chr(1) + disk_list[2], LCD_LINE_2)
  lcd_string(chr(1) + disk_list[3], LCD_LINE_3)

def proc_get(disk_list):
  lcd_custom(1,[0x1F,0x19,0x17,0x17,0x17,0x17,0x19,0x1F]) # CPU C
  lcd_custom(3,[0x1F,0x13,0x15,0x15,0x13,0x17,0x17,0x1F]) # CPU P
  lcd_custom(4,[0x1F,0x15,0x15,0x15,0x15,0x15,0x1B,0x1F]) # CPU U
  #lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # reserved
  #lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # reserved
  lcd_string(chr(1) + chr(3) + chr(4) + disk_list[4], LCD_LINE_2)
  lcd_string(chr(1) + chr(3) + chr(4) + disk_list[5], LCD_LINE_3)


def main():
  # Main program block

  # Initialise display
  lcd_init()
  lcd_custom(0,[0x04,0x0A,0x0A,0x0E,0x0E,0x1F,0x1F,0x0E]) # thermometer
  #lcd_custom(1,[0x15,0x1F,0x15,0x04,0x04,0x04,0x0E,0x1F]) # wifiy
  lcd_custom(2,[0x00,0x02,0x03,0x02,0x0e,0x1e,0x0c,0x00]) # music note
  #lcd_custom(3,[0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F,0x1F]) # full block
  #lcd_custom(4,[0x1F,0x11,0x11,0x11,0x11,0x11,0x11,0x1F]) # empty block
  #lcd_custom(5,[0x02,0x06,0x0E,0x1E,0x06,0x06,0x06,0x06]) # up
  lcd_custom(6,[0x1F,0x1F,0x0E,0x04,0x04,0x0A,0x11,0x1F]) # clock
  #lcd_custom(7,[0x0C,0x0C,0x0C,0x0C,0x0F,0x0E,0x0C,0x08]) # down

  while True:
	lcd_b2=open("/root/mpdlcd/lcd_b2.txt",'r') # txrx
	lcd_b4=open("/root/mpdlcd/lcd_b4.txt",'r') # temp
	lcd_wifi=open("/root/mpdlcd/lcd_wifi.txt",'r') # wifi

	b3_list=open('/root/mpdlcd/lcd_b3.txt').read().splitlines()

	b2=lcd_b2.read()
	b4=lcd_b4.read()
	wifi=lcd_wifi.read()

	lcd_b2.close()
	lcd_b4.close()
	lcd_wifi.close()

	mpd_head_get()
	ud_get(b2)
	ss_get(b3_list,wifi)
	temp_time_get(b4)

	mpc_get()
	old_station = station
	for j in range (0, len(station)):
                lcd_text = station[j:(j+20)]
                lcd_string(lcd_text,LCD_LINE_1)
                temp_time_get(b4)
                if j == 0:
                        lcd_text = station[j:(j+20)]
                        lcd_string(lcd_text,LCD_LINE_1)
                        ud_get(b2)
                        temp_time_get(b4)
                        #lcd_string(str_pad,LCD_LINE_1)
                        ss_get(b3_list,wifi)
                if j == (len(station)//4):
                        lcd_text = station[j:(j+20)]
                        lcd_string(lcd_text,LCD_LINE_1)
                        disk_get(disk_list)
                        temp_time_get(b4)
                if j == (len(station)//4+len(station)//4):
                        lcd_text = station[j:(j+20)]
                        lcd_string(lcd_text,LCD_LINE_1)
                        mem_get(disk_list)
                        temp_time_get(b4)
                if j == (len(station)//4+len(station)//4+len(station)//4):
                        lcd_text = station[j:(j+20)]
                        lcd_string(lcd_text,LCD_LINE_1)
                        proc_get(disk_list)
                        temp_time_get(b4)
                mpc_get()
                if station != old_station: break
                old_station=station
                #time.sleep(0.5)
        del b3_list[:]
        del disk_list[:]

if __name__ == '__main__':
  try:
    main()
  except KeyboardInterrupt:
    pass
  finally:
    lcd_byte(0x01, LCD_CMD)
    lcd_string("Goodbye!",LCD_LINE_1)
