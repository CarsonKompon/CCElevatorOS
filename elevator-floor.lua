peripheral.find("modem", rednet.open)

IS_MOVING = false
local checkTimer = os.startTimer(1)

term.clear()
print("ElevatorOS Floor Handler v1.4a")

function getTime()
 return textutils.formatTime(os.time())
end

function myStop()
 rednet.broadcast("elevator_stop")
 print("[" .. getTime() .. "] Elevator Stopped (SELF)")
 IS_MOVING = false
end

function netStop(sender)
 print("[" .. getTime() .. "] Elevator Stopped (" .. sender .. ")")
 IS_MOVING = false    
end

function netMoving(sender)
 print("[" .. getTime() .. "] Elevator Moving (" .. sender .. ")")
 IS_MOVING = true
end

while true do
	event, sender, message = os.pullEvent()
	if event == "redstone" then
		if rs.getInput("back") then
			checkTimer = os.startTimer(1)
		end
 elseif event == "timer" then
  if sender == checkTimer and rs.getInput("back") then
   myStop()
  end
	elseif event == "rednet_message" then
		if message == "elevator_stop" then
   netStop(sender)
  elseif message == "elevator_start" then
   netMoving(sender)
  elseif message == "elevator_reboot" then
   shell.execute("reboot")
  end
	end 
end