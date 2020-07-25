from gpiozero import Button, LED
from signal import pause

led = LED(21)

def InputHigh():
    print(" high")
    led.on()

def InputLow():
    print(" low")
    led.off()

print("GPIO mapping 12 to 21")
Input = Button(12,pull_up=False)
Input.when_pressed = InputHigh
Input.when_released = InputLow

pause()
