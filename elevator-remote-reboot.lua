-- This is to be used from a remote source
-- (typically a wireless pocket computer)

peripheral.find("modem", rednet.open)

rednet.broadcast("elevator_reboot")