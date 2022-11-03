peripheral.find("modem", rednet.open)

IS_MOVING = false
local redstoneTimer = os.startTimer(0.25)

term.clear()
print("ElevatorOS Receiver v1.4")

function getTime()
 return textutils.formatTime(os.time())
end

function myMove()
 print("[" .. getTime() .. "] Elevator Moving (SELF)")
 rednet.broadcast("elevator_start")
 redstone.setOutput("bottom", true)
 IS_MOVING = true
 redstoneTimer = os.startTimer(0.25)
end

function myRedstone()
 redstone.setOutput("bottom", false)
end

function netStop(sender)
 print("[" .. getTime() .. "] Elevator Stopped (" .. sender .. ")")
 IS_MOVING = false   
end

function netMove(sender)
 print("[" .. getTime() .. "] Elevator Moving (" .. sender .. ")")
 IS_MOVING = false
end

function checkOutput()
 if outputting then
  rednet.broadcast("elevator_start")
  IS_MOVING = true
  redstone.setOutput("bottom", true)
  sleep(0.25)
  redstone.setOutput("bottom", false)
  sleep(3)
  rednet.broadcast("elevator_check")
  outputting = false
 end
 os.sleep()
end

while true do
	event = { os.pullEvent() }
	if event[1] == "redstone" then
		if not IS_MOVING and rs.getInput("top") then
   myMove()
		end
 elseif event[1] == "timer" then
  if event[2] == redstoneTimer then
   myRedstone()
  end
	elseif event[1] == "rednet_message" then
		if event[3] == "elevator_stop" then
			netStop(event[2])
  elseif event[3] == "elevator_start" then
			netMove(event[2])
  elseif event[3] == "elevator_reboot" then
   shell.execute("reboot")
		end
	end
end